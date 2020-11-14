(defpackage ui-test/tests/main
  (:use :cl
        :ui-test
        :rove))
(in-package :ui-test/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :ui-test)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
