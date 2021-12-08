(define-sort Elt () Int)
(define-sort Set () (Array Elt Bool))
(define-sort IntMap () (Array Elt Elt))
(define-fun set_emp () Set ((as const Set) false))
(define-fun set_mem ((x Elt) (s Set)) Bool (select s x))
(define-fun set_add ((s Set) (x Elt)) Set  (store s x true))
(define-fun set_cap ((s1 Set) (s2 Set)) Set ((_ map and) s1 s2))
(define-fun set_cup ((s1 Set) (s2 Set)) Set ((_ map or) s1 s2))
(define-fun set_com ((s Set)) Set ((_ map not) s))
(define-fun set_dif ((s1 Set) (s2 Set)) Set (set_cap s1 (set_com s2)))
(define-fun set_sub ((s1 Set) (s2 Set)) Bool (= set_emp (set_dif s1 s2)))
(define-fun set_minus ((s1 Set) (x Elt)) Set (set_dif s1 (set_add set_emp x)))
(declare-fun set_size (Set) Int)

(declare-const abort Int)
(declare-const ack Int)
(declare-const bottom (Array Int Int))
(declare-const c Int)
(declare-const cmsg Int)
(declare-const committed Int)
(declare-const decision (Array Int Int))
(declare-const id (Array Int Int))
(declare-const msg (Array Int Int))
(declare-const p Set)
(declare-const prop Int)
(declare-const reply Int)
(declare-const val (Array Int Int))
(declare-const value (Array Int Int))
(assert (not (and (and (forall ((i Int))
                               (=> (and (set_mem i set_emp))
                                   (and (= (select value i) 0)
                                        (= (select val i) prop))))
                       (forall ((A Int))
                               (=> (set_mem A set_emp)
                                   true)))
                  (forall ((A Int)
                           (r Set)
                           (value (Array Int Int))
                           (id (Array Int Int))
                           (val (Array Int Int))
                           (msg (Array Int Int))
                           (cmsg Int)
                           (abort Int))
                          (=> (and (and (forall ((i Int))
                                                (=> (and (set_mem i r))
                                                    (and (= (select value i) 0)
                                                         (= (select val i) prop))))
                                        (forall ((A Int))
                                                (=> (set_mem A r)
                                                    true)))
                                   (set_mem A p)
                                   (not (set_mem A r)))
                              (and (and (=> (= (select (store msg A 0) A) 1)
                                            (and (forall ((i Int))
                                                         (=> (and (set_mem i (set_add r A)))
                                                             (and (= (select (store value A 0) i) 0)
                                                                  (= (select (store val A prop) i) prop))))
                                                 (forall ((A Int))
                                                         (=> (set_mem A (set_add r A))
                                                             true))))
                                        (=> (not (= (select (store msg A 0) A) 1))
                                            (and (forall ((i Int))
                                                         (=> (and (set_mem i (set_add r A)))
                                                             (and (= (select (store value A 0) i) 0)
                                                                  (= (select (store val A prop) i) prop))))
                                                 (forall ((A Int))
                                                         (=> (set_mem A (set_add r A))
                                                             true)))))
                                   (and (=> (= (select (store msg A 1) A) 1)
                                            (and (forall ((i Int))
                                                         (=> (and (set_mem i (set_add r A)))
                                                             (and (= (select (store value A 0) i) 0)
                                                                  (= (select (store val A prop) i) prop))))
                                                 (forall ((A Int))
                                                         (=> (set_mem A (set_add r A))
                                                             true))))
                                        (=> (not (= (select (store msg A 1) A) 1))
                                            (and (forall ((i Int))
                                                         (=> (and (set_mem i (set_add r A)))
                                                             (and (= (select (store value A 0) i) 0)
                                                                  (= (select (store val A prop) i) prop))))
                                                 (forall ((A Int))
                                                         (=> (set_mem A (set_add r A))
                                                             true))))))))
                  (forall ((A Int)
                           (r Set)
                           (value (Array Int Int))
                           (id (Array Int Int))
                           (val (Array Int Int))
                           (msg (Array Int Int))
                           (cmsg Int)
                           (abort Int))
                          (=> (and (forall ((i Int))
                                           (=> (and (set_mem i p))
                                               (and (= (select value i) 0)
                                                    (= (select val i) prop))))
                                   (forall ((A Int))
                                           (=> (set_mem A p)
                                               true)))
                              (and (=> (= abort 0)
                                       (and (and (forall ((i Int))
                                                         (and (=> (and (set_mem i set_emp)
                                                                       (= 1 1))
                                                                  (= (select value i) (select val i)))
                                                              (=> (and (set_mem i p)
                                                                       (= 1 0))
                                                                  (= (select value i) 0))))
                                                 (forall ((A Int))
                                                         (=> (set_mem A set_emp)
                                                             true)))
                                            (forall ((A Int)
                                                     (rr Set)
                                                     (id (Array Int Int))
                                                     (decision (Array Int Int))
                                                     (value (Array Int Int))
                                                     (ack Int))
                                                    (=> (and (and (forall ((i Int))
                                                                          (and (=> (and (set_mem i rr)
                                                                                        (= 1 1))
                                                                                   (= (select value i) (select val i)))
                                                                               (=> (and (set_mem i p)
                                                                                        (= 1 0))
                                                                                   (= (select value i) 0))))
                                                                  (forall ((A Int))
                                                                          (=> (set_mem A rr)
                                                                              true)))
                                                             (set_mem A p)
                                                             (not (set_mem A rr)))
                                                        (and (=> (= (select (store decision A 1) A) 1)
                                                                 (and (forall ((i Int))
                                                                              (and (=> (and (set_mem i (set_add rr A))
                                                                                            (= 1 1))
                                                                                       (= (select (store value A (select val A)) i) (select val i)))
                                                                                   (=> (and (set_mem i p)
                                                                                            (= 1 0))
                                                                                       (= (select (store value A (select val A)) i) 0))))
                                                                      (forall ((A Int))
                                                                              (=> (set_mem A (set_add rr A))
                                                                                  true))))
                                                             (=> (not (= (select (store decision A 1) A) 1))
                                                                 (and (forall ((i Int))
                                                                              (and (=> (and (set_mem i (set_add rr A))
                                                                                            (= 1 1))
                                                                                       (= (select value i) (select val i)))
                                                                                   (=> (and (set_mem i p)
                                                                                            (= 1 0))
                                                                                       (= (select value i) 0))))
                                                                      (forall ((A Int))
                                                                              (=> (set_mem A (set_add rr A))
                                                                                  true)))))))
                                            (forall ((A Int)
                                                     (rr Set)
                                                     (id (Array Int Int))
                                                     (decision (Array Int Int))
                                                     (value (Array Int Int))
                                                     (ack Int))
                                                    (=> (and (forall ((i Int))
                                                                     (and (=> (and (set_mem i p)
                                                                                   (= 1 1))
                                                                              (= (select value i) (select val i)))
                                                                          (=> (and (set_mem i p)
                                                                                   (= 1 0))
                                                                              (= (select value i) 0))))
                                                             (forall ((A Int))
                                                                     (=> (set_mem A p)
                                                                         true)))
                                                        (and (forall ((i Int))
                                                                     (=> (and (set_mem i p)
                                                                              (= 1 1))
                                                                         (= (select value i) prop)))
                                                             (forall ((i Int))
                                                                     (=> (and (set_mem i p)
                                                                              (= 1 0))
                                                                         (= (select value i) 0))))))))
                                   (=> (not (= abort 0))
                                       (and (and (forall ((i Int))
                                                         (and (=> (and (set_mem i set_emp)
                                                                       (= 0 1))
                                                                  (= (select value i) (select val i)))
                                                              (=> (and (set_mem i p)
                                                                       (= 0 0))
                                                                  (= (select value i) 0))))
                                                 (forall ((A Int))
                                                         (=> (set_mem A set_emp)
                                                             true)))
                                            (forall ((A Int)
                                                     (rr Set)
                                                     (id (Array Int Int))
                                                     (decision (Array Int Int))
                                                     (value (Array Int Int))
                                                     (ack Int))
                                                    (=> (and (and (forall ((i Int))
                                                                          (and (=> (and (set_mem i rr)
                                                                                        (= 0 1))
                                                                                   (= (select value i) (select val i)))
                                                                               (=> (and (set_mem i p)
                                                                                        (= 0 0))
                                                                                   (= (select value i) 0))))
                                                                  (forall ((A Int))
                                                                          (=> (set_mem A rr)
                                                                              true)))
                                                             (set_mem A p)
                                                             (not (set_mem A rr)))
                                                        (and (=> (= (select (store decision A 0) A) 1)
                                                                 (and (forall ((i Int))
                                                                              (and (=> (and (set_mem i (set_add rr A))
                                                                                            (= 0 1))
                                                                                       (= (select (store value A (select val A)) i) (select val i)))
                                                                                   (=> (and (set_mem i p)
                                                                                            (= 0 0))
                                                                                       (= (select (store value A (select val A)) i) 0))))
                                                                      (forall ((A Int))
                                                                              (=> (set_mem A (set_add rr A))
                                                                                  true))))
                                                             (=> (not (= (select (store decision A 0) A) 1))
                                                                 (and (forall ((i Int))
                                                                              (and (=> (and (set_mem i (set_add rr A))
                                                                                            (= 0 1))
                                                                                       (= (select value i) (select val i)))
                                                                                   (=> (and (set_mem i p)
                                                                                            (= 0 0))
                                                                                       (= (select value i) 0))))
                                                                      (forall ((A Int))
                                                                              (=> (set_mem A (set_add rr A))
                                                                                  true)))))))
                                            (forall ((A Int)
                                                     (rr Set)
                                                     (id (Array Int Int))
                                                     (decision (Array Int Int))
                                                     (value (Array Int Int))
                                                     (ack Int))
                                                    (=> (and (forall ((i Int))
                                                                     (and (=> (and (set_mem i p)
                                                                                   (= 0 1))
                                                                              (= (select value i) (select val i)))
                                                                          (=> (and (set_mem i p)
                                                                                   (= 0 0))
                                                                              (= (select value i) 0))))
                                                             (forall ((A Int))
                                                                     (=> (set_mem A p)
                                                                         true)))
                                                        (and (forall ((i Int))
                                                                     (=> (and (set_mem i p)
                                                                              (= 0 1))
                                                                         (= (select value i) prop)))
                                                             (forall ((i Int))
                                                                     (=> (and (set_mem i p)
                                                                              (= 0 0))
                                                                         (= (select value i) 0))))))))))))))
(check-sat)