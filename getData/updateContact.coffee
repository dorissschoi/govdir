exports.insertdb = insertdb = (callback) ->
  env = require("govdirenv")
  log4js = require("log4js")
  logger = log4js.getLogger()
  mongoose = require("mongoose")
  
  getdata = require("./step2.coffee")
  userModel = require("../model.coffee").userModel
  
  pending = 1
  alldata = []
  getdata.getdir (contactArr) ->
    #logger.debug "Getdata..."
    pending--
    alldata = contactArr
    loaddata alldata  if pending is 0

  loaddata = (alldata) ->
    contactdata = uniquedata(alldata)
    userModel.remove (err) ->
      return handleError(err)  if err
      logger.debug "Remove model..."
      createdata contactdata

  createdata = (contactdata) ->
    pending = 0
    logger.debug "Insert data..."
    i = 0

    while i < contactdata.length
      pending++
      contactrec = new userModel(
        name: contactdata[i].name
        title: contactdata[i].title
        phone: contactdata[i].phone
        email: contactdata[i].email
      )
      contactrec.save (err) ->
        console.log "save failed"  if err
        pending--
  
      i++
  uniquedata = (alldata) ->
    currdata = ""
    distinctarr = []
    IsDup = false
    i = 0

    while i < alldata.length
      currdata = JSON.parse(alldata[i])
      u = 0

      while u < currdata.length
        IsDup = false
        a = 0

		
        while a < distinctarr.length
          IsDup = true  if distinctarr[a].name is currdata[u].name
          a++
        unless IsDup
          distinctarr.push
            name: currdata[u].name
            title: currdata[u].title
            phone: currdata[u].phone
            email: currdata[u].email

        u++
      i++
    distinctarr
