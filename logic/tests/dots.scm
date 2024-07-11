(job ?x (computer programmer))

(address ?x ?y)

(supervisor ?x ?x)

(job ?x (computer ?type))

(job ?x (computer . ?type))

;; Exercise 4.55:
;; 1. all people supervised by Ben Bitdiddle;
(supervisor ?x (Bitdiddle Ben))

;; 2. the names and jobs of all people in the accounting division;
(job ?person (accounting . ?role))

;; 3. the names and addresses of all people who live in Slumerville.
(address ?name (Slumerville . ?rest))