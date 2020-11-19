(defsystem "ui-test"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:cl-tui)
  :components ((:module "src"
                :components
                ((:file "colors")
                 (:file "building")
                 (:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "ui-test/tests"))))

(defsystem "ui-test/tests"
  :author ""
  :license ""
  :depends-on ("ui-test"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for ui-test"
  :perform (test-op (op c) (symbol-call :rove :run c)))
