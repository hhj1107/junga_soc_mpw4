docker run -v $OPENLANE_ROOT:/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -v $PWD:/project -v $CARAVEL_ROOT:$CARAVEL_ROOT -e PDK_ROOT=$PDK_ROOT -e CARAVEL_ROOT=$CARAVEL_ROOT -u $(id -u $USER):$(id -g $USER) $OPENLANE_IMAGE_NAME sh -c "cd /project/openlane && flow.tcl -design ./user_project_wrapper -save_path .. -save -tag user_project_wrapper -overwrite"

exit $?
