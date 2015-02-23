exports.getdir = getdir = (callback) ->
  env = require("govdirenv")
  http = require("http")
  log4js = require("log4js")
  logger = log4js.getLogger()
  htmlparser = require("htmlparser2")
  readcontact = require("./getcontact.coffee")
  options =
    timeout: env.getdata_timeout
    hostname: env.getdata_host
    port: env.getdata_port
    method: env.getdata_method
    path: env.getdata_dirurl

  dataurl = []
  levelArray = {}
  startindex = ""
  str = ""
  req = http.request(options, (res) ->
    res.setEncoding "utf8"
    res.on "data", (chunk) ->
      str += chunk
      console.log chunk

    res.on "end", ->
      recid = 0
      recdiff = 10
      parser = new htmlparser.Parser(
        onopentag: (name, attribs) ->
          startindex = attribs.class  if name is "p"
          if name is "a"
            levelArray[startindex] = attribs.title
            exclude = ["level_0", "level_1"]
            if levelArray["level_1"] is "Office of the Government Chief Information Officer" and exclude.indexOf(startindex) is -1
              if startindex is "level_2"
                recid = recid + recdiff
                dataurl.push
                  recid: recid
                  url: attribs.href
                  division: attribs.title
                  contact: ""

              else
                recid = recid + 1
                dataurl.push
                  recid: recid
                  url: attribs.href
                  division: attribs.title
                  contact: ""

                recdiff = recdiff - 1

        onend: ->
          afterloop = ->
            output = []
            i = 0

            while i < dataurl.length
              u = 0

              while u < datalist.length
                output.push JSON.stringify(datalist[u].contact)  if datalist[u].url is dataurl[i].url
                u++
              i++
            
            callback output
          urllist = []
          pending = 0
          datalist = []
          i = 0

          while i < dataurl.length
            urllist.push dataurl[i].url
            i++
            
          urllist.forEach (f) ->
            pending++
            readcontact.getdata f, (contactArr) ->
              pending--
              datalist.push
                url: f
                contact: contactArr

              afterloop datalist  if pending is 0


      )
      parser.write str
      parser.end()

    res.on "error", (e) ->
      logger.debug "problem with response: " + e.message

  )
  req.on "error", (e) ->
    logger.debug "problem with request: " + e.message

  
  # write data to request body
  req.end()
