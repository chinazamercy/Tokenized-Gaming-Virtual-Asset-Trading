;; Publisher Verification Contract
;; Manages verification of gaming publishers

(define-map verified-publishers principal bool)
(define-map publisher-details principal {name: (string-ascii 50), website: (string-ascii 100)})

(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-verified (err u102))

;; Verify a gaming publisher
(define-public (verify-publisher (publisher principal) (name (string-ascii 50)) (website (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
    (asserts! (is-none (map-get? verified-publishers publisher)) err-already-verified)
    (map-set verified-publishers publisher true)
    (map-set publisher-details publisher {name: name, website: website})
    (ok true)))

;; Check if publisher is verified
(define-read-only (is-publisher-verified (publisher principal))
  (default-to false (map-get? verified-publishers publisher)))

;; Get publisher details
(define-read-only (get-publisher-details (publisher principal))
  (map-get? publisher-details publisher))

;; Revoke publisher verification
(define-public (revoke-publisher (publisher principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
    (asserts! (is-publisher-verified publisher) err-not-verified)
    (map-delete verified-publishers publisher)
    (map-delete publisher-details publisher)
    (ok true)))
