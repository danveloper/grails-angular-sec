import app.Role
import app.User
import app.UserRole

class BootStrap {

    def init = { servletContext ->

      Role userRole = Role.findByAuthority("ROLE_USER")
      Role adminRole = Role.findByAuthority("ROLE_ADMIN")

      if (!userRole) {
        userRole = new Role(authority: "ROLE_USER").save(flush: true, failOnError: true)
      }
      if (!adminRole) {
        adminRole = new Role(authority: "ROLE_ADMIN").save(flush: true, failOnError: true)
      }

      if (!User.findByUsername("danielpwoods@gmail.com")) {
        def dan = new User(username: "danielpwoods@gmail.com", password: "foobar123").save(flush: true, failOnError: true)
        UserRole.create(dan, userRole)
        UserRole.create(dan, adminRole)
        dan.save flush: true
      }

    }
    def destroy = {
    }
}
