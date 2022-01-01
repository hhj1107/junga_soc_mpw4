#!/bin/bash
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# comma seperated test ids
IDS=$1
# simulation mode : RTL/GL
SIM_MODE=$2

DV_TEST_IDS=(${IDS//,/ })

export TARGET_PATH=$(pwd)
export CARAVEL_ROOT=$(pwd)/caravel

cd ..
export PDK_ROOT=$(pwd)/pdks
DV_PATH=$TARGET_PATH/verilog/dv

if [ ! -d $TARGET_PATH ] 
then
    echo "Directory target [$TARGET_PATH] DOES NOT exists." 
    exit 3 
fi

if [ ! -d $PDK_ROOT ] 
then
    echo "Directory pdk [$PDK_ROOT] DOES NOT exists." 
    exit 3 
fi

if [ ! -d $DV_PATH ] 
then
    echo "Directory dv [$DV_PATH] DOES NOT exists." 
    exit 3
fi

for id in "${DV_TEST_IDS[@]}"
do
    $TARGET_PATH/.github/scripts/dv/run-dv.sh $PDK_ROOT $DV_PATH $id $SIM_MODE

    echo "Done test $id $SIM_MODE"

    VERDICT_FILE=$TARGET_PATH/verilog/dv/$id.out

    if [ -f $VERDICT_FILE ]; then
        cnt=$(grep "Pass" $VERDICT_FILE -s | wc -l)
        if ! [[ $cnt ]]; then cnt = 0; fi
    else
        echo "DV check failed due to subscript failure. Please review the logs";
        exit 2;
    fi

    echo "Verdict: $cnt"

    if [[ $cnt -ne 1 ]]; then 
        exit 1; 
    fi
done

exit 0;
