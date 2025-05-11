import { Application } from '@hotwired/stimulus'

//import { definitionsFromContext } from "stimulus/webpack-helpers"
//const context = require.context(".", true, /_controller\.js$/)
//application.load(definitionsFromContext(context))
import ToastController from './toast-controller'

const application: Application = Application.start()

// Configure Stimulus development experience
application.debug = false

application.register('toast', ToastController)

export { application }
