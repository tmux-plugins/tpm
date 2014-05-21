# How to create Tmux plugins

Creating a new plugin is easy.

For demonstration purposes we'll create a simple plugin that lists all
installed TPM plugins. Yes, a plugin that lists plugins :) We'll bind that to
`prefix + T`.

### 1. create a new git project

TPM depends on git for downloading and updating plugins.

To create a new git project:

    $ mkdir tmux_my_plugin
    $ cd tmux_my_plugin
    $ git init

### 2. create a `*.tmux` plugin run file

When it sources a plugin, TPM executes all `*.tmux` files in your plugins'
directory. That's how plugins are run.

Create a plugin run file in plugin directory:

    $ touch my_plugin.tmux
    $ chmod +x my_plugin.tmux

You can have more than one `*.tmux` file, and all will get executed. Usually
however, you'll need just one.

### 3. create a plugin key binding

We want the behavior of the plugin to trigger when a user hits `prefix + T`.

Key `T` is chosen:
 - it's kind of a mnemonic for `TPM`
 - the key is not used by Tmux natively. Tmux man page, KEY BINDINGS section
   contains a list of all the bindings Tmux uses. We don't want to override a
   Tmux default, and there's plenty of unused keys.

Open the plugin run file in your favorite text editor:

    $ vim my_plugin.tmux
    # or
    $ subl my_plugin.tmux

Put the following content in the file:

    #!/usr/env/bin bash

    CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    tmux bind-key T run-shell "$CURRENT_DIR/scripts/tmux_list_plugins.sh"

As you can see, plugin run file is a simple bash script that sets up binding.

When pressed, `prefix + T` will now execute another shell script:
`tmux_list_plugins.sh`. That script should be in `scripts/` directory -
relative to the plugin run file.


### 4. create a script that does the job

Now that we have the binding, let's create a script that's invoked on
`prefix + T`.

    $ mkdir scripts
    $ touch scripts/tmux_list_plugins.sh
    $ chmod +x scripts/tmux_list_plugins.sh

And here's the script content:

    #!/usr/env/bin bash

    # fetching the value of "tpm_plugins" option
    option_value=$(tmux show-option -gqv "@tpm_plugins")

    # displaying variable content
    echo $option_value

### 5. try it out

To try if this works, execute the plugin run file:

    $ ./my_plugin.tmux

That should set up the key binding. Now hit `prefix + T` and see if it works.

### 6. publish the plugin

When everything works, push the plugin to an online git repository, preferably
Github.

Other users can install your plugin by just adding plugin git URL to the
`@tpm_plugins` list in their `.tmux.conf`.

If the plugin is on Github, your users will be able to use the shorthand of
`github_username/repository`.

### Conclusion

Hopefully, that was easy. As you can see, it's mostly shell scripting.

You can use other scripting languages (ruby, phyton etc), but plain old shell
is preferred because it will work almost anywhere.
