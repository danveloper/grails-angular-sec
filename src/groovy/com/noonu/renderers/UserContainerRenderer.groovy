package com.noonu.renderers

import app.User
import grails.rest.render.ContainerRenderer
import grails.rest.render.hal.HalJsonRenderer
import org.codehaus.groovy.grails.web.mime.MimeType
/**
 * User: danielwoods
 * Date: 11/21/13
 */
class UserContainerRenderer extends HalJsonRenderer implements ContainerRenderer<List, User> {

  UserContainerRenderer() {
    super(List, new MimeType("application/json"))
  }

  @Override
  Class<User> getComponentType() { User }
}
