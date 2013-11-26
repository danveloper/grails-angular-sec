package twothreethree

import app.User

class SecurityController {

  def springSecurityService

  def index() {
    if (springSecurityService.currentUser) {
      respond((User)springSecurityService.currentUser)
    } else {
      render status: 401
    }
  }
}
