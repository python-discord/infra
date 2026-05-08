(define-module (services git-mirror)
  #:use-module (services common)
  #:export (%cgit-service %git-mirror-activation-service
                          %git-mirror-update-service))
(use-modules (gnu)
             (guix)
             (guix modules))
(use-package-modules admin bash version-control)
(use-service-modules certbot cgit mcron shepherd web)

(define %mirrored-repos
  (list
   ;; DevOps repos
   (list "github.com" "python-discord" "infra"
    "The PyDis DevOps boiler house, the engine room, where the magic happens.")
   (list "github.com" "python-discord" "king-arthur"
         "Our trusty job-centre recruited assistant for all things DevOps")
   (list "github.com" "python-discord" "ops-site"
    "Webscale-enhanced frontpage for all Python Discord international operations")

   ;; Other Python Discord repos
   (list "github.com" "python-discord" "bot" "")
   (list "github.com" "python-discord" "site" "")
   (list "github.com" "python-discord" "bot-core" "")
   (list "github.com" "python-discord" "sir-lancebot" "")
   (list "github.com" "python-discord" "snekbox" "")
   (list "github.com" "python-discord" "forms-backend" "")
   (list "github.com" "python-discord" "forms-frontend" "")
   (list "github.com" "python-discord" "metricity" "")
   (list "github.com" "python-discord" "blog" "")

   ;; Skunk Works repos
   (list "github.com" "owl-corp" "thallium"
         "Outsourced work with the KGB, MIA, CIA and NSTV")
   (list "github.com" "owl-corp" "pydis-keycloak-theme"
         "Syndicated branding for psy-op campaigns")
   (list "github.com" "owl-corp" "python-poetry-base"
         "Literary works written at our primary base of operations")
   (list "github.com" "owl-corp" "inotify-base"
         "The Owl Corp Early Warning System")
   (list "github.com" "owl-corp" "psql_extended"
         "Owl Corp surveillance storage platform")
   (list "github.com" "owl-corp" "lithium"
    "Digital mitigation strategy for emotional instability in the workplace")

   ;; Uncle Christ's Assorted Works
   (list "git.jchri.st" "jc" "poetry-restrict-plugin"
         "The Last Stand against malware in Python packages")
   (list "git.jchri.st" "jc" "frommilter"
         "A love letter from former DevOps Director Mr. Milter")
   (list "git.jchri.st" "jc" "bolt"
         "State surveillance software for the modern age")
   (list "git.jchri.st" "jc" "twitchup"
         "Total platform subjugation for the Twitch streaming service")
   (list "git.jchri.st" "jc" "dkim-milter-packaging"
    "Packaging for the Mr. Milter's DKIM milter, a tool for email surveillance")
   (list "git.jchri.st" "jc" "ansible-role-nncp"
    "Ansible role for the Node-to-Node Copy Protocol, a tool for exfiltrating data from secure environments")
   (list "git.jchri.st" "jc" "ansible-role-nftables"
    "Ansible role for the nftables firewall, a tool for maintaining secure perimeters around our operations")))

(define %cgit-service
  (service cgit-service-type
           (cgit-configuration (root-title "PyDis DevOps Git Server")
                               (root-desc
                                "Mirrored copies of Python Discord and related projects")
                               ;; XXX: This should support multiple readme files, fix upstream.
                               ;; Alternatively, use plain file
                               (readme ":README.md")
                               (section-from-path 1)
                               (enable-commit-graph? #t)
                               (enable-log-linecount? #t)
                               ;; (enable-blame? #t)
                               (enable-follow-links? #t)
                               (enable-index-owner? #f)
                               (enable-subject-links? #t)
                               (max-stats "year")
                               (repository-sort "age")
                               (logo
                                "https://raw.githubusercontent.com/python-discord/ops-site/main/src/images/icon.png")
                               ;; Default is /srv/git
                               (repository-directory "/srv/git/mirrored")
                               (about-filter (file-append cgit
                                              "/lib/cgit/filters/about-formatting.sh"))
                               (source-filter (file-append cgit
                                               "/lib/cgit/filters/syntax-highlighting.py"))
                               (email-filter (file-append cgit
                                              "/lib/cgit/filters/email-gravatar.py"))
                               (nginx (list (nginx-server-configuration (root
                                                                         cgit)
                                                                        (listen '
                                                                         ("443 ssl http2"))
                                                                        (server-name '
                                                                         ("beta.git.pydis.wtf"))
                                                                        (ssl-certificate
                                                                         (letsencrypt-cert
                                                                          "beta.git.pydis.wtf"))
                                                                        (ssl-certificate-key
                                                                         (letsencrypt-key
                                                                          "beta.git.pydis.wtf"))
                                                                        ;; This should probably be better documented upstream.
                                                                        (locations
                                                                         (list
                                                                          (nginx-location-configuration
                                                                           (uri
                                                                            "@cgit")
                                                                           (body '
                                                                            ("fastcgi_param SCRIPT_FILENAME $document_root/lib/cgit/cgit.cgi;"
                                                                             "fastcgi_param PATH_INFO $uri;"
                                                                             "fastcgi_param QUERY_STRING $args;"
                                                                             "fastcgi_param HTTP_HOST $server_name;"
                                                                             "fastcgi_pass 127.0.0.1:9000;")))))
                                                                        (try-files
                                                                         (list
                                                                          "$uri"
                                                                          "@cgit"))))))))

(define %git-mirror-activation
  ;; Clone our repositories for cgit. Activations run on system reconfigure
  ;; (that is, after deploy) or at boot.
  #~(begin
      (use-modules (guix build utils)
                   (ice-9 match))

      (define (maybe-description->description org name maybe-description)
        "Transform MAYBE-DESCRIPTION to an actual description."
        (if (string=? maybe-description "")
            (string-append "A mirrored copy of the " org "/" name
                           " repository.") maybe-description))

      (define (clone-repo repo)
        "Clone the repository REPO, a triplet HOST, ORG, NAME if it does not already exist locally."
        (match repo
          ((hostname org name maybe-description)
           (let* ((base-directory "/srv/git/mirrored")
                  (org-directory (string-append base-directory "/" org))
                  (repo-directory (string-append org-directory "/" name))
                  (description-file (string-append repo-directory "/"
                                                   "description"))
                  (description (maybe-description->description org name
                                maybe-description)))
             
             (unless (file-exists? repo-directory)
               (begin
                 (mkdir-p org-directory)
                 (invoke (string-append #$git "/bin/git") "clone" "--mirror"
                         (string-append "https://"
                                        hostname
                                        "/"
                                        org
                                        "/"
                                        name
                                        ".git") repo-directory)))
             (call-with-output-file description-file
               (lambda (file)
                 (format file description)))))))

      ;; #$ is "ungexp" (when used in a g-expression, which we have with #~ above)
      ;; meaning "inject this code from the host". The `%` is just from the
      ;; function name. Finally, we quote `'` the value, because otherwise the `(list`
      ;; code from above is treated as forms instead of data.
      (map clone-repo
           '#$%mirrored-repos)))

(define %git-mirror-activation-service
  (simple-service 'git-mirror-activation activation-service-type
                  %git-mirror-activation))

(define %git-mirror-update
  (with-imported-modules (source-module-closure '((guix build utils)))
                         #~(begin
                             (use-modules (guix build utils)
                                          (ice-9 match))

                             (define (update-repo repo)
                               "Update the repository REPO, a triplet HOST, ORG, NAME, to the latest remote changes."

                               (match repo
                                 ((hostname org name _)
                                  (with-directory-excursion (string-append
                                                             "/srv/git/mirrored/"
                                                             org "/" name)
                                    (invoke (string-append #$git "/bin/git")
                                            "fetch" "-q" "--prune")
                                    (mkdir-p "info/web")
                                    (invoke (string-append #$bash "/bin/bash")
                                            "-c"
                                            (string-append #$git
                                             "/bin/git for-each-ref --sort=-committerdate --count=1 --format='%(committerdate:iso8601)' --exclude='refs/pull/*/merge' > info/web/last-modified"))))))

                             ;; See comment in %git-mirror-activation.
                             (map update-repo
                                  '#$%mirrored-repos))))

(define %git-mirror-update-timer
  (shepherd-timer '(git-mirror-update) "*/5 * * * *"
                  #~(#$(program-file "git-mirror-update" %git-mirror-update))
                  #:requirement '(networking user-processes)))

(define %git-mirror-update-service
  (simple-service 'git-mirror-update-timer shepherd-root-service-type
                  (list %git-mirror-update-timer)))
