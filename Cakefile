{spawn, exec} = require 'child_process'
{log, error} = console; print = log

# Start a sub-process
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

task('watch', 'continually compile the coffee scripts', (options) ->
    run('coffee', '-wc', '.')
)

task('coffee', 'compile the coffee scripts', (options) ->
    shell('coffee --compile *.coffee')
)

task('docco', 'build the docs', (options) ->
    shell('docco *.coffee')
)

task('build', 'compile the coffee scripts and build the docs', (options) ->
    invoke 'coffee'
    invoke 'docco'
)