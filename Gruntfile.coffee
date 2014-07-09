fs = require 'fs'
jade = require 'jade'
util = require 'util'

module.exports = (grunt) ->
  
  # register external tasks
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-env'
  
  BUILD_PATH = 'server/client_build'
  APP_PATH = 'client'
  TEMPLATES_PATH = "#{APP_PATH}/coffee/templates"
  DEV_BUILD_PATH = "#{BUILD_PATH}/development"
  JS_DEV_BUILD_PATH = "#{DEV_BUILD_PATH}/js"
  PRODUCTION_BUILD_PATH = "#{BUILD_PATH}/production"
  SERVER_PATH = "server"
  
  grunt.initConfig

    clean:
      development: [DEV_BUILD_PATH]
      production: [PRODUCTION_BUILD_PATH]

    coffee:
      development:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "#{APP_PATH}/coffee"
          dest: "#{DEV_BUILD_PATH}/js"
          src: ["*.coffee", "**/*.coffee"]
          ext: ".js"
        ]

    copy:
      development:
        files: [
          { expand: true, cwd: "#{APP_PATH}/public", src:['**'], dest: DEV_BUILD_PATH }
        ]
  
    # run tests with mocha test, mocha test:unit, or mocha test:controllers
    mochaTest:
      server:
        src: ['test/*']
        
    # express server
    express:
      test:
        options:
          server: './app'
          port: 5000
      development:
        options:
          server: './app'
          port: 3000
    
    watch:
      coffee:
        files: "**/*.coffee"
        tasks: 'coffee:development'

  grunt.registerTask 'testenv', 'Set test Env variable.', ->
    process.env.MODE_ENV = "test"
    

  grunt.registerTask 'test', [
    'development'
    'testenv'
    'express:test'
    'mochaTest:server'
  ]
    
  grunt.registerTask 'development', [
    'clean:development'
    'copy:development'
    'coffee:development'
  ]     
        
  grunt.registerTask 'default', [
    'development'
    'express:development'
    'watch'
  ]
