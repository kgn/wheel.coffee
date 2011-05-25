# Require libraries
{spawn, exec} = require 'child_process'
{log, error} = console; print = log
http = require('http')
querystring = require('querystring')
fs = require('fs')

# Start a subproc.
run = (name, args...) ->
    proc = spawn(name, args)
    proc.stdout.on('data', (buffer) -> print buffer if buffer = buffer.toString().trim())
    proc.stderr.on('data', (buffer) -> error buffer if buffer = buffer.toString().trim())
    proc.on('exit', (status) -> process.exit(1) if status isnt 0)

# Run a shell command.
shell = (cmds, callback) ->
    cmds = [cmds] if Object::toString.apply(cmds) isnt '[object Array]'
    exec(cmds.join(' && '), (err, stdout, stderr) ->
        print trimStdout if trimStdout = stdout.trim()
        error stderr.trim() if err
        callback() if callback
    )

# Minify a javascript file.
# Uses [Marijn Haverbeke's](http://marijnhaverbeke.nl/uglifyjs) HTTP API.
minify = (file, callback) ->
    #read the file
    fs.readFile(file, 'utf8', (err, data) ->
        #throw new Error(err) if err
        
        args = {}
        args.js_code = data
        args.compilation_level = 'WHITESPACE_ONLY'
        args.output_format = 'text'
        args.output_info = 'compiled_code'

        request = http.request({
            method: 'POST', port: 80,
            host: 'marijnhaverbeke.nl',
            path: "/uglifyjs?#{querystring.stringify(args)}"
            }, (response) ->
                return if not response.statusCode is 200
                response.setEncoding('utf8')
                response.on('data', (text) ->
                    callback(text, file) if callback
                )
            )
        request.end()
    )

# **watch**: continually compile the coffee scripts
task('watch', 'continually compile the coffee scripts', (options) ->
    run('coffee', '-wc', '.')
)

# **coffee**: compile the coffee scripts
task('coffee', 'compile the coffee scripts', (options) ->
    fs.readdir('.', (err, files) ->
        throw err if err    
        for file in files
            continue if not /\.coffee$/.test(file)
            print "compile: #{file} -> #{file.replace(/\.coffee$/, '.js')}"
            shell("coffee --compile #{file}")
    )
)

# **docco**: build the docs
task('docco', 'build the docs', (options) ->
    # docco only builds docs for .coffee files, so make a copy of Cakefile as Cakefile.coffee
    fs.readFile('Cakefile', 'utf8', (readerr, text) ->
        throw readerr if readerr
        fs.writeFile('Cakefile.coffee', text, (writeerr) ->
            throw writeerr if writeerr
            shell('docco *.coffee', -> 
                # Delete Cakefile.coffee
                fs.unlink('Cakefile.coffee', (linkerr) ->
                    throw linkerr if linkerr
                )
            )
        )
    )
)

# **minify**: compile the coffee scripts and minify the javascript files
task('minify', 'compile the coffee scripts and minify the javascript files', (options) ->
    invoke 'coffee'
    fs.readdir('.', (err, files) ->
        throw err if err
        for file in files
            continue if not /\.js$/.test(file) or /\.min\.js$/.test(file)
            minify(file, (text, file) ->
                nameparts = file.split('.')
                nameparts[nameparts.length-1] = 'min'
                nameparts.push('js')
                newname = nameparts.join('.')
                print "minify: #{file} -> #{newname}"
                fs.writeFile(newname, text, (writeerr) ->
                    throw writeerr if writeerr
                )
            )
    )
)

# **build**: compile the coffee scripts, minify the javascript and build the docs
task('build', 'compile the coffee scripts, minify the javascript and build the docs', (options) ->
    invoke 'minify'
    invoke 'docco'
)
