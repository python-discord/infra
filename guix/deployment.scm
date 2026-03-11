(define-module (deployment))
(add-to-load-path (dirname (current-filename)))
(use-modules (gnu machine)
             (gnu machine ssh)
             (machines turing))


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
