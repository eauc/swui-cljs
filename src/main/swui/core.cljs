(ns swui.core
  (:require [reagent.core :as rg]
            [swui.debug :as dg]))

(defn root-view
  []
  [:div "Hello world"])


(defn mount-root
  []
  (rg/render [root-view]
             (. js/document getElementById "app")))


(defn ^:dev/before-load stop
  []
  (js/console.log "stop"))


(defn ^:dev/after-load start
  []
  (js/console.log "start")
  (mount-root))


(defn ^:export init
  []
  (dg/setup)
  (start))
