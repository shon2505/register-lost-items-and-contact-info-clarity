;; title: register-lost-items-and-contact-info
;; description: Minimal contract to register lost items with contact info and fetch them by id.
;; note: Intentionally exposes only two functions as requested.

;; Data structures
(define-data-var next-id uint u1)

(define-map items
  uint
  (tuple
    (owner principal)
    (item-name (string-ascii 64))
    (description (string-ascii 256))
    (contact (string-ascii 128))
  )
)

;; Public: register a lost item and contact info. Returns assigned id.
(define-public (register (item-name (string-ascii 64))
                         (description (string-ascii 256))
                         (contact (string-ascii 128)))
  (begin
    (asserts! (> (len item-name) u0) (err u100))
    (asserts! (> (len description) u0) (err u101))
    (asserts! (> (len contact) u0) (err u102))

    (let ((id (var-get next-id)))
      (map-set items id
        (tuple
          (owner tx-sender)
          (item-name item-name)
          (description description)
          (contact contact)))
      (var-set next-id (+ id u1))
      (ok id)))
)

;; Read-only: fetch a registered item by id. Returns (optional tuple ...)
(define-read-only (get-item (id uint))
  (ok (map-get? items id))
)

