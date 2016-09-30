-- premake for iconv

-- days lost trying to get this to work: 2
--- increment as needed.

-- simply put, iconv is a pain to get to build correctly
-- so use the system version if this stops building correctly
--  

iconv_root = path.join(SCAFFOLDING_THIRDPARTY_DIR, "iconv")

iconv_includedirs = {
	iconv_root,
	path.join(iconv_root, "include"),
	
	-- macOS system
	---'/usr/include',
	
	-- macOS homebrew (brew install system/dupes/iconv)
	---'/usr/local/opt/libiconv/include',

	-- Linux

	-- Windows
}

iconv_libdirs = {
	-- macOS system
	---'/usr/lib',

	-- macOS homebrew	
	---'/usr/local/opt/libiconv/lib',

	-- Linux

	-- Windows
}

iconv_links = {
	-- link with project below to be injected into all projects
	--- 'iconv.my',

	-- link with system dll/dylib/so to be injected into all projects
	--- 'iconv'
}
iconv_defines = {}

----
if _OPTIONS["ba-with-thirdparty"] ~= nil then

project "iconv.my" -- different name than system one
	kind "StaticLib"
	language "C"
	flags {}

	defines {		
		"BUILDING_LIBICONV",
		"BUILDING_DLL=0",
		"ENABLE_RELOCATABLE=0",
		"IN_LIBRARY",		
		"NO_XMALLOC",
		stringMacroDeclaration("set_relocation_prefix", "libiconv_set_relocation_prefix"),
		stringMacroDeclaration("relocate", "libiconv_relocate"),
		"HAVE_CONFIG_H",
	}

	includedirs {
		iconv_includedirs,
		path.join(iconv_root, "src"),
		path.join(iconv_root, "include"),
		path.join(iconv_root, "srclib"),
	}

	files {
		path.join(iconv_root, "include/**.h"),
		path.join(iconv_root, "lib/**.h"),
		path.join(iconv_root, "lib/**.c"),		
		path.join(iconv_root, "extras/*.h"),
		path.join(iconv_root, "extras/*.c"),		
	}

	links {
		'iconv.charset',
	}

	buildoptions {
		c11_buildoptions,
	}

	linkoptions {
		c11_linkoptions,
	}


	local cfgs = configurations()
	for i, cfg in ipairs(cfgs) do
		configuration(cfg.terms)
			defines {
				stringMacroDeclaration("LIBDIR", cfg.targetdir),
				stringMacroDeclaration("INSTALLDIR", cfg.targetdir),
			}
	end


project "iconv.charset"
	kind "StaticLib"
	language "C"
	flags {}

	defines {		
		"BUILDING_LIBCHARSET",
		"BUILDING_DLL=0",
		"ENABLE_RELOCATABLE=0",
		"IN_LIBRARY",		
		"NO_XMALLOC",
		stringMacroDeclaration("set_relocation_prefix", "libcharset_set_relocation_prefix"),
		stringMacroDeclaration("relocate", "libcharset_relocate"),
		"HAVE_CONFIG_H",
	}

	includedirs {
		iconv_includedirs,
		path.join(iconv_root, "libcharset/include"),
		path.join(iconv_root, "include"),
	}

	files {
		path.join(iconv_root, "libcharset/**.h"),
		path.join(iconv_root, "libcharset/lib/**.h"),
		path.join(iconv_root, "libcharset/lib/*.c"),
	}

	buildoptions {
		c11_buildoptions,
	}

	linkoptions {
		c11_linkoptions,
	}

	local cfgs = configurations()
	for i, cfg in ipairs(cfgs) do
		configuration(cfg.terms)
			defines {
				stringMacroDeclaration("LIBDIR", cfg.targetdir),
				stringMacroDeclaration("INSTALLDIR", cfg.targetdir),
			}
	end

-- not required to build iconv
--project "iconv.gnulib" 
--	kind "StaticLib"
--	language "C"
--	flags {}

--	defines {
--		"DEPENDS_ON_LIBICONV=1",
--		"DEPENDS_ON_LIBINTL=1",
--		stringMacroDeclaration("EXEEXT", ""),
--	}

--	includedirs {
--		iconv_includedirs,		
--		path.join(iconv_root, "include"),
--		path.join(iconv_root, "lib"),
--		path.join(iconv_root, "srclib"),
--		path.join(iconv_root, "build-aux/snippet"),
--	}

--	files {
--		path.join(iconv_root, "build-aux/**.h"),
--		path.join(iconv_root, "srclib/**.h"),		
--		path.join(iconv_root, "srclib/**.c"),		
--	}

--	buildoptions {
--		c11_buildoptions,
--	}
==
--	linkoptions {
--		c11_linkoptions,
--	}

end
