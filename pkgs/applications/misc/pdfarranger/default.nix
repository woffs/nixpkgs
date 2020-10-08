{ stdenv, fetchFromGitHub, lib
, wrapGAppsHook, intltool
, python3Packages, gtk3, poppler_gi
, genericUpdater, common-updater-scripts
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfarranger";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1z841mljcn17zh03z2klica4mdca0y4fvqgjml2gikbcdacqi7n0";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool
  ] ++ (with python3Packages; [
    setuptools distutils_extra
  ]);

  buildInputs = [
    gtk3 poppler_gi
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pikepdf
    img2pdf
    setuptools
  ];

  # incompatible with wrapGAppsHook
  strictDeps = false;

  doCheck = false; # no tests

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
  };

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using an interactive and intuitive graphical interface";
    platforms = platforms.linux;
    maintainers = with maintainers; [ symphorien ];
    license = licenses.gpl3;
  };
}
