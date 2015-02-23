exports.getdir = (callback) ->
  request = require("request")
  htmlparser = require("htmlparser2")
  readcontact = require('./step3')
  env = require("govdirenv")

  dirurl = env.getdata_dirurl 
  #'http://tel.directory.gov.hk/index_CEDB_ENG.html?accept_disclaimer=yes'  
 
  request dirurl, (error, response, body) ->
    if not error and response.statusCode is 200
      if not error
        str = body
        levelArray = {}
        dataurl = []
        startindex = ""
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
              #console.log 'url:' + f
            
              readcontact.init f, (contactArr) ->
                #console.log contactArr
                pending--
                datalist.push
                  url: f
                  contact: contactArr
            	              
                afterloop datalist if pending is 0
        )
        parser.write str
        parser.end() 
    return 