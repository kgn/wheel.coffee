{spawn, exec} = require 'child_process'
{log, error} = console; print = log
http = require('http')
querystring = require('querystring')
fs = require('fs')

#Start a subproc
run = (name, args...) ->
    proc = spawn(name, args)
    proc.stdout.on('data', (buffer) -> print buffer if buffer = buffer.toString().trim())
    proc.stderr.on('data', (buffer) -> error buffer if buffer = buffer.toString().trim())
    proc.on('exit', (status) -> process.exit(1) if status isnt 0)

# Run a shell command
shell = (cmds) ->
    cmds = [cmds] if Object::toString.apply(cmds) isnt '[object Array]'
    exec(cmds.join(' && '), (err, stdout, stderr) ->
        print trimStdout if trimStdout = stdout.trim()
        error stderr.trim() if err
    )

#Minify a javascript file
minify = (file) ->
    #read the file
    fs.readFile(file, 'utf8', (err, data) ->
        args = {}
        args.js_code = data
        args.compilation_level = 'WHITESPACE_ONLY'
        args.output_format = 'text'
        args.output_info = 'compiled_code'

        request = http.request({
            method: 'POST', port: 80,
            host: 'closure-compiler.appspot.com',
            path: "/compile?#{querystring.stringify(args)}"
            }, (response) ->
                return if not response.statusCode is 200
                response.setEncoding('utf8')
                response.on('data', (text) ->
                    print text
                )
            )
        request.end()
    )

task('watch', 'continually compile the coffee scripts', (options) ->
    run('coffee', '-wc', '.')
)

task('coffee', 'compile the coffee scripts', (options) ->
    shell('coffee --compile *.coffee')
)

task('docco', 'build the docs', (options) ->
    shell('docco *.coffee')
)

task('minify', 'minify javascript files', (options) ->
    minify('pystr.js')
)

task('build', 'compile the coffee scripts, minify the javascript and build the docs', (options) ->
    invoke 'coffee'
    invoke 'minify'
    invoke 'docco'
)
