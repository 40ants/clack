#|
  This file is a part of Slinky package.
  URL: http://github.com/fukamachi/slinky
  Copyright (c) 2011 Eitarow Fukamachi <e.arrows@gmail.com>

  Slinky is freely distributable under the LLGPL License.
|#

#|
  Class of Slinky Application.

  Author: Eitarow Fukamachi (fukamachi_e@ariel-networks.com)
|#

(in-package :slinky.application)

(defclass <slinky-application> ()
  ((name :initarg :name :accessor :get-name)
   (route :accessor :route)
   (root-dir :initarg :root-dir)
   (view-dir :initarg :view-dir :initform *default-view-dir*)
   (action-dir :initarg :action-dir :initform *default-action-dir*)
   (model-dir :initarg :model-dir :initform *default-model-dir*))
  (:metaclass <collect-metaclass>)
  (:documentation "Class of Slinky application."))

(defun make-routing (routing)
  "Create a function for URL routing and return it.
The function takes HTTP Request method and URI string."
  (loop :with hash = (make-hash-table :test 'equal)
        :for (uri-rule action-name method) :in routing
        ;; TODO: about `method' is nil or cons.
        ;; FIXME: this routing function calls `find-action' each requests.
        :do (push (lambda (uri) (when (string= uri-rule uri)
                              (invoke (find-action action-name))))
                  (gethash method hash))
        :finally
        (return (lambda (method uri) (funcall (gethash method hash) uri)))))

(defmethod initialize-instance ((app <slinky-application>) &rest initargs)
  ;; TODO: ...load controller, view and i18n files...
  (setf (route app) (make-routing (assoc :route initargs))))
