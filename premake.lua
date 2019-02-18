-- premake for iconv

-- days lost trying to get this to work: 2
--- increment as needed.

-- simply put, iconv is a pain to get to build correctly
-- so use the system version if this stops building correctly
--  

iconv_script = path.getabsolute(path.getdirectory(_SCRIPT))
iconv_root = path.join(iconv_script, "iconv")

iconv_includedirs = {
	path.join(iconv_root, "my"),
	iconv_root,
	path.join(iconv_root, "include"),
}

iconv_libdirs = {}

iconv_links = {}
iconv_defines = {}

iconv_defines_internal = {
	"BUILDING_DLL=0",
	"ENABLE_RELOCATABLE=0",
	"HAVE_CONFIG_H",
	"IN_LIBRARY",
	"NO_XMALLOC",
}

----


project "iconv.my" -- different name than system one
	kind "StaticLib"
	language "C"
	flags {}

	defines {
		"BUILDING_LIBICONV",
		iconv_defines_internal,
		stringMacroDeclaration("relocate", "libiconv_relocate"),
		stringMacroDeclaration("set_relocation_prefix", "libiconv_set_relocation_prefix"),
	}

	includedirs {
		iconv_includedirs,
		path.join(iconv_root, "src"),
		path.join(iconv_root, "include"),
		--path.join(iconv_root, "srclib"),
	}

	files {
		path.join(iconv_root, "**.h"),
		path.join(iconv_root, "lib/**.h"),
		path.join(iconv_root, "lib/**.c"),
		path.join(iconv_root, "extras/*.h"),
		path.join(iconv_root, "extras/*.c"),
	}

	removefiles {
		path.join(iconv_root, "lib", "gentranslit.c"),
		--path.join(iconv_root, "lib", "relocatable.c"),
		path.join(iconv_root, "lib", "genflags.c"),
		path.join(iconv_root, "lib", "genaliases2.c"),
		path.join(iconv_root, "lib", "genaliases.c"),
	}

	links {
		'iconv.charset',
	}

	build_c89()

	local cfgs = configurations()
	for i, cfg in ipairs(cfgs) do
		configuration(cfg.terms)
			defines {
				stringMacroDeclaration("LIBDIR", cfg.targetdir or ""),
				stringMacroDeclaration("INSTALLDIR", cfg.targetdir or ""),
			}
	end

---

project "iconv.my.noi18n" -- different name than system one
	kind "StaticLib"
	language "C"
	flags {}

	defines {
		"BUILDING_LIBICONV",
		"NO_I18N",
		iconv_defines_internal,
		stringMacroDeclaration("relocate", "libiconv_relocate"),
		stringMacroDeclaration("set_relocation_prefix", "libiconv_set_relocation_prefix"),
	}

	includedirs {
		iconv_includedirs,
		path.join(iconv_root, "src"),
		path.join(iconv_root, "include"),
		path.join(iconv_root, "srclib"),
	}

	files {
		path.join(iconv_root, "**.h"),
		path.join(iconv_root, "src/**.c"),
	}

	links {
		'iconv.charset',
	}

	build_c89()

	local cfgs = configurations()
	for i, cfg in ipairs(cfgs) do
		configuration(cfg.terms)
			defines {
				stringMacroDeclaration("LIBDIR", cfg.targetdir or ""),
				stringMacroDeclaration("INSTALLDIR", cfg.targetdir or ""),
			}
	end

---

project "iconv.charset"
	kind "StaticLib"
	language "C"
	flags {}

	defines {
		"BUILDING_LIBCHARSET",
		iconv_defines_internal,
		stringMacroDeclaration("relocate", "libcharset_relocate"),
		stringMacroDeclaration("set_relocation_prefix", "libcharset_set_relocation_prefix"),
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

	build_c89()

	local cfgs = configurations()
	for i, cfg in ipairs(cfgs) do
		configuration(cfg.terms)
			defines {
				stringMacroDeclaration("LIBDIR", cfg.targetdir or ""),
				stringMacroDeclaration("INSTALLDIR", cfg.targetdir or ""),
			}
	end

