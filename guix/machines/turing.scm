;; Module imports
(define-module (machines turing)
  #:export (%turing-os))
(use-modules (gnu)
             (guix)
             (sops secrets)
             (sops services sops))
(use-service-modules admin
                     certbot
                     databases
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
                     vim)

;; Getting "unauthorized public key"?
;; your key needs to be in the guix authorized-keys, search for `guix-archive-key`.
;; Add your key there, then:
;;     scp -r . turing.box.pydis.wtf:guix
;;     ssh turing.box.pydis.wtf
;;     cd guix
;;     vim turing.scm
;;     # Delete the `(list (machine ...))` stuff
;;     # Add %turing-os
;;     # Save
;;     sudo guix system reconfigure turing.scm

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
                     (password-authentication?  #f)
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
                (service nftables-service-type)
                (service ntp-service-type)
                %hidden-service-turing
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
    (host-name "u-76")
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
    (packages (cons* age %base-packages))
    (sudoers-file (plain-file "sudoers" "root ALL=(ALL) ALL
%wheel ALL=NOPASSWD: ALL
"))
    (services (modify-services %services
                (guix-service-type config =>
                                   (guix-configuration
                                     (inherit config)
                                     (authorized-keys
                                       (append (list (guix-archive-key "jc")
                                                     (guix-archive-key "jc2")
                                                     (guix-archive-key "lovelace")
                                                     (guix-archive-key "joe-lovelace")
                                                     (guix-archive-key "joe-macbook"))
                                               %default-authorized-guix-keys))))))))

%turing-os
