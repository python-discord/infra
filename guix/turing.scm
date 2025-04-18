;; Module imports
(use-modules (gnu)
             (guix)
             (gnu packages linux)
             (gnu packages tmux)
             (gnu packages vim))
(use-service-modules networking ssh)
(use-package-modules bootloaders)

;; Getting "unauthorized public key"?
;; your key needs to be in the guix authorized-keys, search for `guix-archive-key`.
;; Add your key there, then:
;;     scp -r . turing.box.chrisjl.dev:guix
;;     ssh turing.box.chrisjl.dev
;;     cd guix
;;     vim turing.scm
;;     # Delete the `(list (machine ...))` stuff
;;     # Add %turing-os
;;     # Save
;;     sudo guix system reconfigure turing.scm

(define %this-dir (dirname (current-filename)))

; https://logs.guix.gnu.org/guile/2017-07-01.log
; <rekado>davidl: a syntax checker probably wouldn’t help you here. “invalid field specifier” means that you have a record (e.g. operating-system) and you try to initialise a field that doesn’t exist.
; <rekado>davidl: this can mean that you close an expression too early, which makes it seem that its contents are fields for the parent expression.
; <rekado>davidl: but without more context it’s hard to say what’s wrong in your case.
;
; alternatively, that means you're trying to `guix system reconfigure`

(define (file-from-cwd path)
  (local-file (string-append %this-dir path)))

(define (ssh-key name)
  (file-from-cwd (string-append "/ssh-keys/" name ".pub")))

(define (guix-archive-key name)
  (file-from-cwd (string-append "/guix-acl-keys/" name ".pub")))

(define %services
  (append (list (service openssh-service-type
                   (openssh-configuration
                     (permit-root-login #f)
                     (password-authentication?  #f)
                     (authorized-keys `(("cj" ,(ssh-key "chris"))
                                        ("jc" ,(ssh-key "jc"))
                                        ("j" ,(ssh-key "jb")
                                             ,(ssh-key "jb2"))))))
                (service dhcp-client-service-type)
                (simple-service 'resolv-conf etc-service-type
                                (list `("resolv.conf" ,(plain-file
                                                        "resolv.conf"
                                                        "nameserver 1.1.1.1 1.0.0.1\n")))))
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
    (packages (cons* vim %base-packages))
    (sudoers-file (plain-file "sudoers" "root ALL=(ALL) ALL
%wheel ALL=NOPASSWD: ALL
"))
    (services (modify-services %services
                (guix-service-type config =>
                                   (guix-configuration
                                     (inherit config)
                                     (authorized-keys
                                       (append (list (guix-archive-key "jc"))
                                               %default-authorized-guix-keys))))))))

; local deployments:
; SSHKEY=path/to/key USER=myuser guix deploy turing.scm
; USER is usually implicitly declared somewhere
(list (machine
        (operating-system %turing-os)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration
                         (host-name "turing.box.chrisjl.dev")
                         (build-locally? #f)
                         (system "x86_64-linux")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvvi6P/G+rZ2qUZ+anluvFQwYM/WFZkERygd9X9+xqU")
                         (user (getenv "USER"))
                         (identity (getenv "SSHKEY"))))))
