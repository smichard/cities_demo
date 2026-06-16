#!/bin/bash
if [ -f ./website/index_2.html ]; then
        mv website/index.html website/index_tmp.html
        mv website/index_2.html website/index.html
        mv website/index_3.html website/index_2.html
        mv website/index_4.html website/index_3.html
        mv website/index_5.html website/index_4.html
        mv website/index_tmp.html website/index_5.html
		echo changes performed
fi