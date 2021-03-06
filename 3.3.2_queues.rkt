#lang racket
(require "sicp-lang.rkt")
(provide (all-defined-out))

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item)
  (set-car! queue item))
(define (set-rear-ptr! queue item)
  (set-cdr! queue item))
(define (empty-queue? queue)
  (null? (front-ptr queue)))

(define (make-queue) (mcons '() '()))
(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an
              empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (mcons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else (set-cdr! (rear-ptr queue)
                          new-pair)
                (set-rear-ptr! queue new-pair)
                queue))))
(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with
                 an empty queue" queue))
        (else (set-front-ptr!
               queue
               (cdr (front-ptr queue)))
              queue)))

(define (print-queue queue)
  (define (print-seq seq)
    (cond [(null? seq) (display "")]
          [(null? (cdr seq)) (display (car seq))]
          [else (display (car seq))
                (display " ")
                (print-seq (cdr seq))]))
  (display "<")
  (print-seq (front-ptr queue))
  (display ">"))

;; Ex. 3.22
(define (make-queue*)
  (let ((front-ptr null)
        (rear-ptr null))
    (define (empty?)
      (null? front-ptr))
    (define (insert! x)
      (let ((new-pair (mcons x null)))
        (cond [(empty?) (set! front-ptr new-pair)
                        (set! rear-ptr new-pair)]
              [else (set-cdr! rear-ptr new-pair)
                    (set! rear-ptr new-pair)])))
    (define (delete!)
      (cond [(empty?) (error "DELETE! called with
                              an empty queue")]
            [else (set! front-ptr (cdr front-ptr))]))
    (define (dispatch m)
      (cond [(eq? m 'insert!) insert!]
            [(eq? m 'delete!) (delete!)]
            [(eq? m 'front) front-ptr]
            [else (error "unknown message: QUEUE" m)]))
    dispatch))

(define (insert-queue!* q x)
  ((q 'insert!) x))
(define (delete-queue!* q)
  (q 'delete!))
(define (front-ptr* q)
  (q 'front))

;; Ex 3.23
(define (make-dnode prev content next)
  (define (set-prev! x)
    (set! prev x))
  (define (set-next! x)
    (set! next x))
  (define (dispatch m)
    (cond [(eq? m 'prev) prev]
          [(eq? m 'content) content]
          [(eq? m 'next) next]
          [(eq? m 'sp) set-prev!]
          [(eq? m 'sn) set-next!]))
  dispatch)
(define (dnode-prev dn)
  (dn 'prev))
(define (dnode-content dn)
  (if (null? dn)
      (error "empty deque")
      (dn 'content)))
(define (dnode-next dn)
  (dn 'next))
(define (dnode-set-prev! dn x)
  ((dn 'sp) x))
(define (dnode-set-next! dn x)
  ((dn 'sn) x))
(define empty-dnode null)
(define (empty-dnode? dn)
  (null? dn))

(define (make-deque)
  (let ([front empty-dnode]
        [rear empty-dnode])
    (define (empty?)
      (or (empty-dnode? front)
          (empty-dnode? rear)))
    (define (front-insert! x)
      (if (empty?)
          (let ([new-node (make-dnode null x null)])
            (set! front new-node)
            (set! rear new-node))
          (let ([new-front (make-dnode null x front)])
            (dnode-set-prev! front new-front)
            (set! front new-front))))
    (define (front-delete!)
      (if (empty?)
          (error "FRONT-DELETE! called
                  with an empty deque")
          (begin
            (set! front (dnode-next front))
            (dnode-set-prev! front null))))
    (define (rear-insert! x)
      (if (empty?)
          (let ([new-node (make-dnode null x null)])
            (set! front new-node)
            (set! rear new-node))
          (let ([new-rear (make-dnode rear x null)])
            (dnode-set-next! rear new-rear)
            (set! rear new-rear))))
    (define (rear-delete!)
      (if (empty?)
          (error "FRONT-DELETE! called
                  with an empty deque")
          (begin
            (set! rear (dnode-prev rear))
            (dnode-set-next! rear null))))
    (define (dispatch m)
      (cond [(eq? m 'fi) front-insert!]
            [(eq? m 'fd) (front-delete!)]
            [(eq? m 'ri) rear-insert!]
            [(eq? m 'rd) (rear-delete!)]
            [(eq? m 'e?) (empty?)]
            [(eq? m 'fp) front]
            [(eq? m 'f) (dnode-content front)]
            [(eq? m 'r) (dnode-content rear)]
            [else (error "unknown message: DEQUE" m)]))
  dispatch))

(define (empty-deque? q)
  (q 'e?))
(define (front-ptr-deque q)
  (q 'fp))
(define (front-deque q)
  (q 'f))
(define (rear-deque q)
  (q 'r))
(define (front-insert-deque! q x)
  ((q 'fi) x))
(define (front-delete-deque! q)
  (q 'fd))
(define (rear-insert-deque! q x)
  ((q 'ri) x))
(define (rear-delete-deque! q)
  (q 'rd))
(define (print-deque q)
  (define (print-seq dn)
    (if (null? (dnode-next dn))
        (display (dnode-content dn))
        (begin
          (display (dnode-content dn))
          (display " ")
          (print-seq (dnode-next dn)))))
  (display "<")
  (if (empty-deque? q)
      (display "")
      (print-seq (front-ptr-deque q)))
  (display ">"))
