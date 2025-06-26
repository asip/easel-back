import { Application } from '@hotwired/stimulus'

import ToastController from './toast-controller'

const application: Application = Application.start()

// Configure Stimulus development experience
application.debug = false

application.register('toast', ToastController)

export { application }
