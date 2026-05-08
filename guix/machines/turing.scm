;; Module imports
(define-module (machines turing)
  #:export (%turing-os))
(use-modules (gnu)
             (guix)
             (sops secrets)
             (sops services sops))
(use-service-modules admin
                     certbot
                     cgit
                     databases
                     dbus  ; for elogind
                     desktop
                     networking
                     security
                     ssh
                     syncthing
                     web)
(use-package-modules bootloaders
                     databases
                     golang-crypto
                     linux
                     tmux
                     version-control
                     vim)

(define %guix-dir (dirname (dirname (canonicalize-path (current-filename)))))

(define %secrets-yaml (local-file (string-append %guix-dir "/secrets.yaml")))

(define (resource path)
  (local-file (string-append %guix-dir "/resources/" path)))

(define (ssh-key name)
  (resource (string-append "/ssh-keys/" name ".pub")))

(define (guix-archive-key name)
  (resource (string-append "/guix-acl-keys/" name ".pub")))

(define %hidden-service-turing
    (simple-service 'hidden-service-turing tor-service-type
                    (list (tor-onion-service-configuration
                            (name "turing")
                            (mapping '((22 "127.0.0.1:22")))))))

(define %motd
  (resource "/motd.txt"))

(define %certbot-deploy-hook
  (program-file
   "nginx-deploy-hook"
   #~(let ((pid (call-with-input-file "/var/run/nginx/pid" read)))
       (kill pid SIGHUP))))

(define (letsencrypt-path hostname filename)
  (string-append "/etc/letsencrypt/live/" hostname "/" filename))

(define (letsencrypt-key hostname)
  (letsencrypt-path hostname "privkey.pem"))

(define (letsencrypt-cert hostname)
  (letsencrypt-path hostname "fullchain.pem"))

(define %services
  (append (list (service openssh-service-type
                   (openssh-configuration
                     (permit-root-login #f)
                     (password-authentication? #f)
                     (authorized-keys `(("cj" ,(ssh-key "chris")
                                              ,(ssh-key "chris-lovelace"))
                                        ("jc" ,(ssh-key "jc"))
                                        ("j" ,(ssh-key "jb")
                                             ,(ssh-key "jb2")
                                             ,(ssh-key "jb-lovelace"))))))
                (service static-networking-service-type
                         (list
                           (static-networking
                             (addresses
                               (list
                                 (network-address
                                   (device "eth0")
                                   (value "5.252.225.193/22"))
                                 (network-address
                                   (device "eth0")
                                   (value "2a03:4000:40:2f2:7460:66ff:feda:145b/64"))))
                             (routes
                               (list
                                 (network-route
                                   (destination "default")
                                   (gateway "5.252.224.1"))))
                             (name-servers
                               '("1.1.1.1" "1.0.0.1")))))
                (service postgresql-service-type
                         (postgresql-configuration
                           (postgresql postgresql-16)))
                (service tor-service-type)
                (service nftables-service-type
                         (nftables-configuration
                           (ruleset (resource "nftables.conf"))))
                (service fail2ban-service-type
                         (fail2ban-configuration
                           (extra-jails
                             (list
                               (fail2ban-jail-configuration
                                 (name "sshd")
                                 (enabled? #t))))))
                (service ntp-service-type)
                %hidden-service-turing
                (service cgit-service-type
                         (cgit-configuration
                           (root-title "PyDis DevOps Server")
                           (root-desc "Mirrored copies of Python Discord and related projects")
                           ; XXX: This should support multiple readme files, fix upstream.
                           ; Alternatively, use plain file
                           (root-readme ":README.md")
                           (section-from-path 1)
                           (enable-commit-graph? #t)
                           (enable-log-linecount? #t)
                           ; (enable-blame? #t)
                           (enable-follow-links? #t)
                           (enable-index-owner? #f)
                           (enable-subject-links? #t)
                           (max-stats "year")
                           (repository-sort "age")
                           ; Default is /srv/git
                           (repository-directory "/srv/git/mirrored")
                           (about-filter (file-append cgit "/lib/cgit/filters/about-formatting.sh"))
                           (source-filter (file-append cgit "/lib/cgit/filters/syntax-highlighting.py"))
                           (email-filter (file-append cgit "/lib/cgit/filters/email-gravatar.py"))
                           (nginx
                             (list
                               (nginx-server-configuration
                                 (root cgit)
                                 (listen '("443 ssl http2"))
                                 (server-name '("beta.git.pydis.wtf"))
                                  (ssl-certificate (letsencrypt-cert "beta.git.pydis.wtf"))
                                  (ssl-certificate-key (letsencrypt-key "beta.git.pydis.wtf"))
                                 ; This should probably be better documented upstream.
                                 (locations
                                   (list
                                     (nginx-location-configuration
                                       (uri "@cgit")
                                       (body '("fastcgi_param SCRIPT_FILENAME $document_root/lib/cgit/cgit.cgi;"
                                               "fastcgi_param PATH_INFO $uri;"
                                               "fastcgi_param QUERY_STRING $args;"
                                               "fastcgi_param HTTP_HOST $server_name;"
                                               "fastcgi_pass 127.0.0.1:9000;")))))
                                 (try-files (list "$uri" "@cgit")))))
                           (root-desc "Python Discord DevOps' Software Archive")))
              (service nginx-service-type
                         (nginx-configuration
                           (server-blocks
                             (list
                               (nginx-server-configuration
                                 (listen '("443 ssl http2"))
                                 (server-name '("turing.box.pydis.wtf"))
                                 (ssl-certificate (letsencrypt-cert "turing.box.pydis.wtf"))
                                 (ssl-certificate-key (letsencrypt-key "turing.box.pydis.wtf"))
                                 (root "/var/www/turing.box.pydis.wtf"))))))
; The below is added by the certbot role
;                                     (listen '("80" "[::]:80"))
;                                     (server-name '("turing.box.pydis.wtf"))
;                                     (root "/var/www/owlcorp.uk")
;                                     (locations
;                                       (list
;                                         (nginx-location-configuration
;                                           ; Certbot webroot serving
;                                           (uri "/.well-known")
;                                           (body (list "root /var/www; "))))))))))
;
                (service sops-secrets-service-type
                         (sops-service-configuration
                           (generate-key? #f)
                           (secrets
                             (list
                               (sops-secret
                                 (key '("good"))
                                 (file %secrets-yaml)
                                 (user "root")
                                 (group "root")
                                 (permissions #o400))))))
                (service dbus-root-service-type)
                (service elogind-service-type)
                (service certbot-service-type
                         (certbot-configuration
                          (email "ops@owlcorp.uk")
                          ; Do not add certbot configuration to nginx automatically
                          ; XXX: seems broken, report upstream?
                          ; (default-location #f)
                          (webroot "/var/www")
                          (certificates
                           (list
                            (certificate-configuration
                              (domains '("beta.git.pydis.wtf"))
                              (deploy-hook %certbot-deploy-hook))
                            (certificate-configuration
                             (domains '("turing.box.pydis.wtf"))
                             (deploy-hook %certbot-deploy-hook))))))
                (service unattended-upgrade-service-type)
	        (simple-service 'motd etc-service-type
				(list `("motd" ,%motd))))
               %base-services))

;; Operating system description
(define %turing-os
  (operating-system
    (locale "en_GB.utf8")
    (timezone "UTC")
    (keyboard-layout (keyboard-layout "gb"))
    (bootloader (bootloader-configuration
                  (bootloader grub-bootloader)
                  (targets '("/dev/vda"))
                  (keyboard-layout keyboard-layout)))
    (file-systems (cons* (file-system
                           (mount-point "/")
                           (device "/dev/vda2")
                           (type "ext4"))
                          %base-file-systems))
    (host-name "turing")
    (users (cons* (user-account
                    (name "cj")
                    (comment "Chris")
                    (group "users")
                    (home-directory "/home/cj")
                    (supplementary-groups '("wheel" "netdev" "audio" "video")))
                  (user-account
                    (name "jc")
                    (comment "void")
                    (group "users")
                    (home-directory "/home/jc")
                    (supplementary-groups '("wheel" "netdev" "audio" "video")))
                  (user-account
                    (name "j")
                    (comment "J")
                    (group "users")
                    (home-directory "/home/j")
                    (supplementary-groups '("wheel" "netdev" "audio" "video")))
                  %base-user-accounts))
    (packages (cons* age tmux %base-packages))
    (sudoers-file (plain-file "sudoers" "root ALL=(ALL) ALL
%wheel ALL=NOPASSWD: ALL
"))
    (services (modify-services %services
                (guix-service-type config =>
                                   (guix-configuration
                                     (inherit config)
                                     (privileged? #f)
                                     (authorized-keys
                                       (append (list (guix-archive-key "jc")
                                                     (guix-archive-key "jc2")
                                                     (guix-archive-key "lovelace")
                                                     (guix-archive-key "joe-lovelace")
                                                     (guix-archive-key "joe-macbook"))
                                               %default-authorized-guix-keys))))))))

%turing-os
