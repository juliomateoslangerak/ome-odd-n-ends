Setting Up Git Repo
===================

1. fork openmicroscopy/openmicroscopy on GitHub
2. mkdir cocone.ome-ws && cd cocone.ome-ws
3. git clone --recursive https://github.com/c0c0n3/openmicroscopy.git
4. cd openmicroscopy
5. git remote rename origin cocone
6. git remote add ome https://github.com/openmicroscopy/openmicroscopy.git
7. git fetch ome
8. git checkout -b dev_5_1 ome/dev_5_1
9. git branch -d develop
   (Just moving develop out of the way as I won't use it locally. Got this
         warning: deleting branch 'develop' that has been merged to
                  'refs/remotes/cocone/develop', but not yet merged to HEAD.
         Deleted branch develop (was fb4ef8b).
    which is harmless in my case, to see why read: 
    + http://stackoverflow.com/questions/12147360/git-branch-d-gives-warning)
10. ./build.py build-dev
    (should succeed)
11. git clean -ffxd :/
    (see http://stackoverflow.com/questions/61212/how-do-i-remove-local-untracked-files-from-my-current-git-branch)
12. git checkout -b bg-import ome/dev_5_1
13. git push cocone bg-import
14. ./build.py build-dev
    (should succeed)
15. set up new Eclipse workspace: ~/cocone.ome-ws
     + color theme: solarized dark
     + colors & fonts -> basic: Monaco 13
     + java -> compiler -> compliance level: 1.6
     + file -> import -> existing projs into ws -> root dir: components

