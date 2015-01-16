package = "itorch"
version = "scm-1"

source = {
   url = "git://github.com/soumith/iTorch.git",
}

description = {
   summary = "iPython kernel for Lua / Torch",
   detailed = [[
   ]],
   homepage = "https://github.com/soumith/iTorch",
   license = "BSD"
}

dependencies = {
   "torch >= 7.0",
   "luafilesystem",
   "penlight",
   "lua-cjson",
   "uuid",
   "lbase64",
   "env",
   "image",
   "lzmq"
}

build = {
   type = "command",
   build_command = [[
   ipy=$(which ipython)   
   if [ -x "$ipy" ]
   then
	ipybase=$(dirname $(ipython locate profile))
	rm -rf $ipybase/profile_torch
	ipython profile create torch
	echo 'c.KernelManager.kernel_cmd = ["$(LUA_BINDIR)/itorch_launcher","{connection_file}"]' >>$ipybase/profile_torch/ipython_config.py   	
	echo "c.Session.key = b''" >>$ipybase/profile_torch/ipython_config.py
	echo "c.Session.keyfile = b''" >>$ipybase/profile_torch/ipython_config.py
	mkdir -p $ipybase/profile_torch/static/base/images
	cp ipynblogo.png $ipybase/profile_torch/static/base/images
	mkdir -p $ipybase/profile_torch/static/custom/
	cp custom.js $ipybase/profile_torch/static/custom/
	cp custom.css $ipybase/profile_torch/static/custom/
	cp itorch $(LUA_BINDIR)/
	cp itorch_launcher $(LUA_BINDIR)/
	cmake -E make_directory build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)" && $(MAKE)	
   else
	echo "Error: could not find ipython in PATH. Do you have it installed?"
   fi
  
]],
   install_command = "cd build && $(MAKE) install"
}
