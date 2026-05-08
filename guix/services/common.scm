(define-module (services common)
  #:export (letsencrypt-key letsencrypt-cert))

(define (letsencrypt-path hostname filename)
  (string-append "/etc/letsencrypt/live/" hostname "/" filename))

(define (letsencrypt-key hostname)
  (letsencrypt-path hostname "privkey.pem"))

(define (letsencrypt-cert hostname)
  (letsencrypt-path hostname "fullchain.pem"))
