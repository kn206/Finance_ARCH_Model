{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "18839370",
   "metadata": {
    "papermill": {
     "duration": 0.007103,
     "end_time": "2023-05-28T17:03:24.335762",
     "exception": false,
     "start_time": "2023-05-28T17:03:24.328659",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Fitting the ARCH Model"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "7b9d22f9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:24.351706Z",
     "iopub.status.busy": "2023-05-28T17:03:24.349371Z",
     "iopub.status.idle": "2023-05-28T17:03:26.158138Z",
     "shell.execute_reply": "2023-05-28T17:03:26.156497Z"
    },
    "papermill": {
     "duration": 1.819473,
     "end_time": "2023-05-28T17:03:26.160921",
     "exception": false,
     "start_time": "2023-05-28T17:03:24.341448",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Loading required package: parallel\n",
      "\n",
      "\n",
      "Attaching package: ‘rugarch’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:stats’:\n",
      "\n",
      "    sigma\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(readxl)\n",
    "library(rugarch)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "bc971894",
   "metadata": {
    "papermill": {
     "duration": 0.005748,
     "end_time": "2023-05-28T17:03:26.172686",
     "exception": false,
     "start_time": "2023-05-28T17:03:26.166938",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Loading the Data into R"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "e6a5dae3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:26.220317Z",
     "iopub.status.busy": "2023-05-28T17:03:26.186001Z",
     "iopub.status.idle": "2023-05-28T17:03:26.311726Z",
     "shell.execute_reply": "2023-05-28T17:03:26.309775Z"
    },
    "papermill": {
     "duration": 0.136232,
     "end_time": "2023-05-28T17:03:26.314636",
     "exception": false,
     "start_time": "2023-05-28T17:03:26.178404",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "cbkdata<-read_excel(\"/kaggle/input/kenya-exchange-rate/investingcom.xlsx\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "6c72705f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:26.329686Z",
     "iopub.status.busy": "2023-05-28T17:03:26.328178Z",
     "iopub.status.idle": "2023-05-28T17:03:26.358183Z",
     "shell.execute_reply": "2023-05-28T17:03:26.356252Z"
    },
    "papermill": {
     "duration": 0.040006,
     "end_time": "2023-05-28T17:03:26.360557",
     "exception": false,
     "start_time": "2023-05-28T17:03:26.320551",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A tibble: 6 × 6</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>Date</th><th scope=col>EURO</th><th scope=col>POUND</th><th scope=col>USD</th><th scope=col>RAND</th><th scope=col>YEN</th></tr>\n",
       "\t<tr><th scope=col>&lt;dttm&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>2003-01-03</td><td>80.830</td><td>124.849</td><td>77.575</td><td>9.22</td><td>0.8494</td></tr>\n",
       "\t<tr><td>2003-01-06</td><td>81.225</td><td>124.818</td><td>77.575</td><td>9.09</td><td>0.8382</td></tr>\n",
       "\t<tr><td>2003-01-07</td><td>81.020</td><td>124.826</td><td>77.800</td><td>8.98</td><td>0.8367</td></tr>\n",
       "\t<tr><td>2003-01-08</td><td>82.035</td><td>126.048</td><td>78.150</td><td>9.14</td><td>0.8430</td></tr>\n",
       "\t<tr><td>2003-01-09</td><td>81.690</td><td>125.146</td><td>77.900</td><td>9.10</td><td>0.8300</td></tr>\n",
       "\t<tr><td>2003-01-10</td><td>81.910</td><td>124.524</td><td>77.450</td><td>9.12</td><td>0.8302</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A tibble: 6 × 6\n",
       "\\begin{tabular}{llllll}\n",
       " Date & EURO & POUND & USD & RAND & YEN\\\\\n",
       " <dttm> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl>\\\\\n",
       "\\hline\n",
       "\t 2003-01-03 & 80.830 & 124.849 & 77.575 & 9.22 & 0.8494\\\\\n",
       "\t 2003-01-06 & 81.225 & 124.818 & 77.575 & 9.09 & 0.8382\\\\\n",
       "\t 2003-01-07 & 81.020 & 124.826 & 77.800 & 8.98 & 0.8367\\\\\n",
       "\t 2003-01-08 & 82.035 & 126.048 & 78.150 & 9.14 & 0.8430\\\\\n",
       "\t 2003-01-09 & 81.690 & 125.146 & 77.900 & 9.10 & 0.8300\\\\\n",
       "\t 2003-01-10 & 81.910 & 124.524 & 77.450 & 9.12 & 0.8302\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A tibble: 6 × 6\n",
       "\n",
       "| Date &lt;dttm&gt; | EURO &lt;dbl&gt; | POUND &lt;dbl&gt; | USD &lt;dbl&gt; | RAND &lt;dbl&gt; | YEN &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|\n",
       "| 2003-01-03 | 80.830 | 124.849 | 77.575 | 9.22 | 0.8494 |\n",
       "| 2003-01-06 | 81.225 | 124.818 | 77.575 | 9.09 | 0.8382 |\n",
       "| 2003-01-07 | 81.020 | 124.826 | 77.800 | 8.98 | 0.8367 |\n",
       "| 2003-01-08 | 82.035 | 126.048 | 78.150 | 9.14 | 0.8430 |\n",
       "| 2003-01-09 | 81.690 | 125.146 | 77.900 | 9.10 | 0.8300 |\n",
       "| 2003-01-10 | 81.910 | 124.524 | 77.450 | 9.12 | 0.8302 |\n",
       "\n"
      ],
      "text/plain": [
       "  Date       EURO   POUND   USD    RAND YEN   \n",
       "1 2003-01-03 80.830 124.849 77.575 9.22 0.8494\n",
       "2 2003-01-06 81.225 124.818 77.575 9.09 0.8382\n",
       "3 2003-01-07 81.020 124.826 77.800 8.98 0.8367\n",
       "4 2003-01-08 82.035 126.048 78.150 9.14 0.8430\n",
       "5 2003-01-09 81.690 125.146 77.900 9.10 0.8300\n",
       "6 2003-01-10 81.910 124.524 77.450 9.12 0.8302"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(cbkdata)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "cee976d4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:26.376738Z",
     "iopub.status.busy": "2023-05-28T17:03:26.375416Z",
     "iopub.status.idle": "2023-05-28T17:03:27.156763Z",
     "shell.execute_reply": "2023-05-28T17:03:27.154798Z"
    },
    "papermill": {
     "duration": 0.791625,
     "end_time": "2023-05-28T17:03:27.159537",
     "exception": false,
     "start_time": "2023-05-28T17:03:26.367912",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching core tidyverse packages\u001b[22m ──────────────────────── tidyverse 2.0.0 ──\n",
      "\u001b[32m✔\u001b[39m \u001b[34mdplyr    \u001b[39m 1.1.2     \u001b[32m✔\u001b[39m \u001b[34mreadr    \u001b[39m 2.1.4\n",
      "\u001b[32m✔\u001b[39m \u001b[34mforcats  \u001b[39m 1.0.0     \u001b[32m✔\u001b[39m \u001b[34mstringr  \u001b[39m 1.5.0\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2  \u001b[39m 3.4.2     \u001b[32m✔\u001b[39m \u001b[34mtibble   \u001b[39m 3.2.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mlubridate\u001b[39m 1.9.2     \u001b[32m✔\u001b[39m \u001b[34mtidyr    \u001b[39m 1.3.0\n",
      "\u001b[32m✔\u001b[39m \u001b[34mpurrr    \u001b[39m 1.0.1     \n",
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mpurrr\u001b[39m::\u001b[32mreduce()\u001b[39m masks \u001b[34mrugarch\u001b[39m::reduce()\n",
      "\u001b[36mℹ\u001b[39m Use the conflicted package (\u001b[3m\u001b[34m<http://conflicted.r-lib.org/>\u001b[39m\u001b[23m) to force all conflicts to become errors\n"
     ]
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 6 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Returns</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td> 0.000000000</td></tr>\n",
       "\t<tr><th scope=row>2</th><td> 0.002896221</td></tr>\n",
       "\t<tr><th scope=row>3</th><td> 0.004488626</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>-0.003204104</td></tr>\n",
       "\t<tr><th scope=row>5</th><td>-0.005793386</td></tr>\n",
       "\t<tr><th scope=row>6</th><td>-0.005178005</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 6 × 1\n",
       "\\begin{tabular}{r|l}\n",
       "  & Returns\\\\\n",
       "  & <dbl>\\\\\n",
       "\\hline\n",
       "\t1 &  0.000000000\\\\\n",
       "\t2 &  0.002896221\\\\\n",
       "\t3 &  0.004488626\\\\\n",
       "\t4 & -0.003204104\\\\\n",
       "\t5 & -0.005793386\\\\\n",
       "\t6 & -0.005178005\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 6 × 1\n",
       "\n",
       "| <!--/--> | Returns &lt;dbl&gt; |\n",
       "|---|---|\n",
       "| 1 |  0.000000000 |\n",
       "| 2 |  0.002896221 |\n",
       "| 3 |  0.004488626 |\n",
       "| 4 | -0.003204104 |\n",
       "| 5 | -0.005793386 |\n",
       "| 6 | -0.005178005 |\n",
       "\n"
      ],
      "text/plain": [
       "  Returns     \n",
       "1  0.000000000\n",
       "2  0.002896221\n",
       "3  0.004488626\n",
       "4 -0.003204104\n",
       "5 -0.005793386\n",
       "6 -0.005178005"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "\n",
    "# Convert date variable to Date class\n",
    "cbkdata$Date <- as.Date(cbkdata$Date, format = \"%m/%d/%Y\")\n",
    "\n",
    "# Create a new data frame to store the log returns\n",
    "\n",
    "log_returns <- data.frame(\n",
    "  Returns = c(\n",
    "    diff(log(cbkdata$USD)),\n",
    "    diff(log(cbkdata$POUND)),\n",
    "    diff(log(cbkdata$EURO)),\n",
    "    diff(log(cbkdata$YEN)),\n",
    "    diff(log(cbkdata$RAND))\n",
    "  )\n",
    ")\n",
    "\n",
    "# Print the returns data frame\n",
    "head(log_returns)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "741b7786",
   "metadata": {
    "papermill": {
     "duration": 0.006565,
     "end_time": "2023-05-28T17:03:27.172561",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.165996",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    " Is there any serial correlation in the log return series? How do check using ACF and PACF plots\n",
    "and the Ljung-Box statistics?\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "bd9ff32b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:27.188109Z",
     "iopub.status.busy": "2023-05-28T17:03:27.186767Z",
     "iopub.status.idle": "2023-05-28T17:03:27.684409Z",
     "shell.execute_reply": "2023-05-28T17:03:27.681888Z"
    },
    "papermill": {
     "duration": 0.508157,
     "end_time": "2023-05-28T17:03:27.687125",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.178968",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Registered S3 method overwritten by 'quantmod':\n",
      "  method            from\n",
      "  as.zoo.data.frame zoo \n",
      "\n"
     ]
    },
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAIAAAByhViMAAAABmJLR0QA/wD/AP+gvaeTAAAg\nAElEQVR4nOzdeXhU5f3w4WeSkBAWCatsSgURqIo/RYtbFVRAVHCpu6VqpdWCglZbWxXRWq28\nbd3F2rpjwWLdQGNxgxZZrKVuRaGooFYBZVfIAsm8fwQpRQxBSGbO431fXl7JmcPkyzyT8MmZ\nOTOpdDodAABIvpxMDwAAwPYh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHs\nAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh\n7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAi\nIewAACIh7IBkqFy7KPXlcnLym7bscPh3fvTkmysyPSlAxqTS6XSmZwDYssq1i3Lz22xxt9x6\nLX732r8Hd2u6tdd/0N57rVpXGUL4vysnjDlpl68yIkCm5WV6AIDtqWLtkh/3vXjwB/ds7R98\n61//Wr6uMoSww7KyWpgLoC54KBZInjYHPbxkI4sX/mfGE6N3qb/+N9VP/3PvI0tKMjshQEYI\nOyB5cuo1br6RVq3b7T/wR3/+yR4bdnhiaWnNr+2TmVOff/75tZ8/LWXlnBnPP//8qyvKt+/M\nAHVA2AGR2LH3jpvd/slrT1141nFdOrRpWFC/dYcuhxx5+h8mvlyx0Q7TzjnhiCOO+KyisurT\n2Td9/4gjjvj5a0tCCJOP71h1ckbDlidtfJ1rFt+94byNK95btf4P3rx/1Zbces1CCIunjz3x\n4O7NCvPfK6vY5KKZY649cr8uzRrXL2zcdM+D+v963N+/MHV62kO3nNb/kA47Nqtfr17jpi32\n+FbvYVff/vZna7f9hgIi5jl2QCQWPrtow8eDdmxQ9cHkG8/qd/EDaz8/S2zN+/9e/P6/p04a\n98vDhkx7+pb2+bm1NMzSV27tduiFVU/a2+QMtedHHnHEL57//LOyf03/y0+n/+XFj15+4uJ9\n129Ll//ihO4jH5+74Y+UrVg6++Ups1+ecucNt90zffoZu2/1qSHA14QjdkDypNetWbmR5Us/\nfuWFB0+5cXbVpTv2/GWfooIQwofP/uzwz6uuadf9v3PaqUcc2K1qn/dfGN2z73VVHx83+5N0\nOt00b/3PwwN/91Y6nX760LbbMGDFkKN/XlV1m05esbLfNS+EEPIaNM5NpTZsf+qyY94vW38Y\ncd79J2youiYduh/Rr++B+3ar2rl81ZzBh5xYUunVDIDNc8QOSJ6PXjyhqGjzFzXf88RJz/00\nhBBCxfmn31r1ik6dTr3zrbE/rJcKIYQ3xg/pfsodIYSP/nrlz94Ycv2ezbf7eJXrVj28KOfA\n4885+sA9GqRKi3JzVn9+UTpd2Wzfs8bef91h32xT8en713/321dOeD+EUFG++Nf/+fTWTkUh\nhMd+Oa1q52bdrlk8+4q8VAghLJp5Q5sDLg4hlC574er3V13/jSbbfWwgAsIOiEfzvc74+4z7\nOhbmhRBWL7rr8SVrqrb/5rbv1fv86NieJ48+dsh9TywtCSGMH/nP6x/tUxuT9Lvl70+f32PD\npx9udNHDz915aJP8EEJO450vvutXV7Y6o2r7O4tLQqeiEMJ/Stcfulv94YTf/mG3o/oevuc3\nmrfe/8fPT9qj6uhjy2aFtTEzEAEPxQLxWPraH/fs2Pufn60NISx/49EN249vUbjx21RUVV0I\nYek/X6yNMVKpnPvP3XuzF+XkFVVVXZWCxvtv+Dj9+Xm5gwZ1qfqgbNXLPzv3lO67tGi+y14n\nff/CuR+XdNqvV79+/fbZIT8AbI6wA5KnXa+/pDey8pMP7htxeNVFaxa9eO7tb4UQPlvw2Rav\nZ92auVvc5ytI5e7Qqt6X/XRN/e9nm9lt32un/P7y7+/W6r+H5ZYteP3P9948ZNBxXVq16H/+\nbWs8xw74Eh6KBRJvhxbtz7z6L5eOqr+4vCKE8J9HFoRLuzdot/7E2FQqd0LxU/VSm/mDNXmP\nss9tVUtt7ovV/A/nNPzBL+/+wTV3znl58jPPPPPMpGdemPFGSUU6hFBZ8dlfbr/g+D2OmHRe\n1235EkCshB0QhVTe7g3qVYVd2fL3QwhNu/cN4bkQQjpdUbB/r6rzZKuULv1k5brKEEJO3pec\ngvHfa12faGtXv57eqNfKltfKob4QQkXZ+6/+65Oqj7vte8Swb/UZdsWv1322cErxI+ef/eO5\na9aGEP5526wg7IDN8VAsEIkNLwJSsfaTEELjthcc3GR9zF1w8YMbvbHEE7u1a9u6devWrVt/\nZ+w7m7mehf99O7Iduu1Q9cHaknkn3zppbTqEUDl/xiOD+v2ulv4Wpcuf3vdzgx96q2pjXqM2\nhx134t4N61V9WtiuRS19dSDphB0QiQ2PlabXfRpCCDn17xt9atWWufcMbt3toDPOOvs7Rx/c\nfo8TPihbF0JovPNxj/+o24Y/3r5g/YsV/+s33z37B+f+ds6KEEKnM4/bsMOfhx1ZWH+HogYF\nHQ88sfiDNbX0t2jYevAxrdY/iPzQd/fovM/BA4499sjDD9m5xc4PfbImhJBK5Qy96Vu19NWB\npBN2QCR2rb/+uSXln84sT4cQQqfT7/vTz4+u2rhs7vSx99/3aPG0qrcOa77nic+8+lCzvP8+\nGe6y3utfkXjt6jfvu+v3zy1eE0Jo0mnkr47ssGGfivJPV5asS+UUnH/3FbX298h98G9/2LNJ\nQQghnU6//cq0JydMmPTC1A8/XRtCSKVyBlxVfGk37zwBbJ6wAyJxTv92VR+UrZrRa8Q/qz4+\n+bon3/3b2B+c1PcbrVsU1Kvfdpduh/b7zvV3PfWfVx/ev2nBxn/8pIcnXzaoX/tmjXJy8nZo\nsXPXz1+U5NKnZt/7y6H7dWvfoCC3YVHLffqceveUd64/aqfa+4s06XL6Pz+a+/vrftL/kP3a\ntyyqXy83r6BBqw5d+5865I9T3n3iyn6196WBpEul006bBwCIgSN2AACREHYAAJEQdgAAkRB2\nAACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQ\ndgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACR\nEHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAA\nkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACREHYAAJEQdgAAkRB2AACRyMv0\nAAmwcuXK+++/v6SkJNODAABZobCw8Mwzz2zSpEmmB9mUsNuyP/7xj8OHD8/0FABAFsnLyxsy\nZEimp9iUsNuytWvXhhDuvvvuvfbaK9OzAAAZ9tprr51zzjlVeZBthF1NdenSpUePHpmeAgDI\nsNLS0kyP8KWcPAEAEAlhBwAQCWEHABAJYQcAEAlhBwAQCWEHABCJpL7cyfKF8+fOnbd42arV\na0rz6jds0rx1567dOrYpyvRcAAAZk7CwS1esHH/j1bfcPXb6nMVfvLR11/1PHzx8xPBTivJS\ndT8bAEBmJSnsKso/PHu/vca8vjS3XrOehw3s3q1TmxZFBQV568rKVixZ9N682dOnvnTDJac9\nMPbJ12Y80Dbfo8wAwNdLksJuxsVHjnl96cHn3zzu+iHtG25m8srypeNGDR00cmyfCwbPvrNX\nnQ8IAJBJSTqsddmYeY3anDf11mGbrboQQk5+8zNGPHRHzx3feeiKOp4NACDjkhR2b6xe22jn\nAVvcrcchrdaumV0H8wAAZJUkhd2xzQuXz7l+UXlldTtVltwzfkH9pv3qaigAgGyRpLC7fFS/\nspVT99j/5AcnzVpdkd704nTZm1MfG9yn2x0LVvUaOTITAwIAZFKSTp7ofObDf3i577mjHx10\n5CO5+U06du7UtmVRQUG9ivKylUsWvjvvnWWl61KpVO8ht08Y2i3TwwIA1LUkhV0IOYNve67/\noMdvv3dc8eSZc956Zd7s9cftUjkF7Tvt3qd3v9MGDzt2v3aZnRIAICOSFXYhhNCu53HX9Tzu\nuhDS60pWrPh0dUl5fmGDxkVNC70oMQDw9Za8sNsglVfYtEVh00yPAQCQJZJ08gQAANVI8BG7\nzSpfNa1DlxNDCAsXLqzJ/hUVFcXFxaWlpdXs88orr4QQ1q5du+3jVVRUPP/884cffnhubu62\nXxsAwMZiC7t0unzRokU133/y5MkDBw6syZ5jx47t1avXVxzrc08//fSAAQMmTpx4zDHHbONV\nAQBsIrawy2+078yZM2u+f+/evSdMmFD9EbvRo0dPmTKlffv22zxdKCkp2fB/AIDtK7awS+U2\n7tmzZ833z83NHTBgC29TVlxcHELIyfF8RAAgq4kVAIBICDsAgEgIOwCASCTpOXYrFi1cXVFZ\nw53btfPGYgDA10uSwu4ne+9216LParhzOp2u1WEAALJNksLul8893eW+26+88U8lFemme/Y6\nqEOjTE8EAJBFkhR2O+5+8CW/Prh3s3f3vezv3YbeMfHcrpmeCAAgiyTv5Ik9h/420yMAAGSj\n5IVd/g4H79O+dZP63msVAOB/JOmh2A1mfbAw0yMAAGSd5B2xAwBgs4QdAEAkhB0AQCSEHQBA\nJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0A\nQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQd\nAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSE\nHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAk\nhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBA\nJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0A\nQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQd\nAEAk8jI9wHZQUfLh4w8Xv/3h8mY7det7fP8ODWP4SwEAbK2EHbFbPvuJQUcf2qF5g6Ztdhv6\n2+dDCEv+cU+3Vh1PPPOHP7vs0h8OGti51a4j/zw302MCAGRAkg5urVn81J49vvNhWUVh83Z5\nS98ZfckRJa2fefW8H727tuWPfv6jfbu0fP+N6bfeMuaXp+6z09uLBn+jcabnBQCoU0kKuwnf\nPe+j8sqfjfvnr07du7L8418ct+/V3+2bW6/FE+/MOXqnRiGEEH544TmHt9njzBGnPzp4+pkZ\nHhcAoG4l6aHYX834uPHOI3516t4hhJz8VpeOuSmE0Opboz+vuhBCKOo26P91brr09d9mbEoA\ngAxJUti9U7quwY77bfi0YIdvhxCafLPdJrt13alhRen8Op0MACALJCnsDtohf9X8MRWff7pq\n/j0hhI9fnLnJbhPfWpHf+Ft1OxoAQOYlKexGnNFpzSfjew+9+eXZb/9jyiOn9702r7DJ8jk/\nveLPr2/Y5693fv/WDz/d6ZifZXBOAICMSNLJEwf8pnhg8Z4TRl/4rdEXhhBy6jW78/XZLx7d\n9dqT9nrswD49urT64I0Xp/zjvfxGezw4+tBMDwsAUNeSFHa5BTs/+uZb99/6+7+9NOvTem1P\nveiXJ3VteearU8OxJ98/+dk3p4cQQseDTrn9wbu+1Tg/08MCANS1JIVdCCG3oO33L7nq+xtt\nqdd4z/teeOs3782d958VTdt36dqhKGPDAQBkVMLC7su06NClRYdMDwEAkFFJOnkCAIBqRHLE\nboPyVdM6dDkxhLBw4cKa7F9RUVFcXFxaWlrNPgsWLAghVFZWbo8BAQBqS2xhl06XL1q0qOb7\nT548eeDAgTXZc/58L3oMAGS12MIuv9G+M2du+pLF1ejdu/eECROqP2I3evToKVOm7LLLLts8\nHQBALYot7FK5jXv27Fnz/XNzcwcMGFD9PsXFxSGEnBzPRwQAslpSw275wvlz585bvGzV6jWl\nefUbNmneunPXbh3beK0TAODrK2Fhl65YOf7Gq2+5e+z0OYu/eGnrrvufPnj4iOGnFOWl6n42\nAIDMSlLYVZR/ePZ+e415fWluvWY9DxvYvVunNi2KCgry1pWVrViy6L15s6dPfemGS057YOyT\nr814oG2+R04BgK+XJIXdjIuPHPP60oPPv3nc9UPaN9zM5JXlS8eNGjpo5Ng+FwyefWevOh8Q\nACCTknRY67Ix8xq1OW/qrcM2W3UhhJz85meMeOiOnju+89AVdTwbAEDGJSns3li9ttHOWziD\nNYTQ45BWa9fMroN5AACySpLC7tjmhcvnXL+ovNp3gKgsuWf8gvpN+9XVUAAA2SJJYXf5qH5l\nK6fusf/JD06atboivenF6bI3pz42uE+3Oxas6jVyZCYGBADIpCSdPNH5zIf/8HLfc0c/OujI\nR3Lzm3Ts3Klty6KCgnoV5WUrlyx8d947y0rXpVKp3kNunzC0W6aHBQCoa0kKuxByBt/2XP9B\nj99+77jiyTPnvPXKvNnrj9ulcgrad9q9T+9+pw0edux+7TI7JQBARiQr7EIIoV3P467redx1\nIaTXlaxY8enqkvL8wgaNi5oWelFiAODrLXlht0Eqr7Bpi8KmmR4DACBLJOnkCQAAqiHsAAAi\nIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAA\nIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewA\nACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHs\nAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh\n7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAi\nIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAA\nIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewA\nACKRl+kBvoL0Jx981nKnxp9/WvnaX5/626w3P6ss2OWb+x3V78AdclOZnA4AIEMSFnYLnhn9\nvWFXzk7/euncs0MIJR//9bv9Tnn01cUbdmjQZp8bxj157qFtMjcjAEBmJCnslrzy2279f1Ke\natjnnJ1CCOmKT0/Z++iJH63u3v+skw/ft/0Olf96edJtdxcP7bNX0wXzT27bMNPzAgDUqSSF\n3W2nXFueanDXzHfP3rdlCGHhi4MnfrR6n58+OWvU0ev3+MEFPznn9p0PvODCUx49eeqgTM4K\nAFDnknTyxO0LVjXd7eaqqgshLBj7egjh7iv7brxPq55Df9ul2ZJ/Xp+B+QAAMipJYdcsLye3\nYMM5EyEnPyeEsHPBpgcdO7asX1G+sE4nAwDIAkkKuwt3b7rsrZ+8tLK86tNOZ307hPCLWR9v\nvE963fJrX11S2PyYDMwHAJBRSQq70/94bb11HxzW7bDbH5m6cl1lyx63/+Sg1r/rd8y9U96t\n2mHNwpcvGrj3tFVlh17588yOCgBQ95J08kST3Qa/8vBHh532i/NPPGR4QdGuXXdr3aRt2cp/\nfL93p2Etd27fsGzeex9XpNMH/eCmJ37ULdPDAgDUtSQdsQshdDn+yncXvn7DFUMP7Nrqo7dm\n/fVv/6za/tkn7y8sqX/4yeeOmfL2i78fnucligGAr58kHbGrUtD0mxddc9tF14SQXrtsyZLV\nJWtz8+s3bNS0SaN6mR4NACCTkhd2/5Wq16xlm2aZngIAIEsk7KFYAAC+TJKP2G1O+appHbqc\nGEJYuLBGL2VXUVFRXFxcWlpazT4LFiwIIVRWVm6PAQEAaktsYZdOly9atKjm+0+ePHngwIE1\n2XP+/PlfdSgAgLoQW9jlN9p35syZNd+/d+/eEyZMqP6I3ejRo6dMmbLLLrts83QAALUotrBL\n5Tbu2bNnzffPzc0dMGBA9fsUFxeHEHJyPB8RAMhqYgUAIBJJPWK3fOH8uXPnLV62avWa0rz6\nDZs0b925a7eObYoyPRcAQMYkLOzSFSvH33j1LXePnT5n8Rcvbd11/9MHDx8x/JQibz0BAHz9\nJCnsKso/PHu/vca8vjS3XrOehw3s3q1TmxZFBQV568rKVixZ9N682dOnvnTDJac9MPbJ12Y8\n0Dbfo8wAwNdLksJuxsVHjnl96cHn3zzu+iHtG25m8srypeNGDR00cmyfCwbPvrNXnQ8IAJBJ\nSTqsddmYeY3anDf11mGbrboQQk5+8zNGPHRHzx3feeiKOp4NACDjkhR2b6xe22jnLbw0SQih\nxyGt1q6ZXQfzAABklSSF3bHNC5fPuX5RebVv7VVZcs/4BfWb9quroQAAskWSwu7yUf3KVk7d\nY/+TH5w0a3VFetOL02VvTn1scJ9udyxY1WvkyEwMCACQSUk6eaLzmQ//4eW+545+dNCRj+Tm\nN+nYuVPblkUFBfUqystWLln47rx3lpWuS6VSvYfcPmFot0wPCwBQ15IUdiHkDL7tuf6DHr/9\n3nHFk2fOeeuVebPXH7dL5RS077R7n979Ths87Nj92mV2SgCAjEhW2IUQQruex13X87jrQkiv\nK1mx4tPVJeX5hQ0aFzUt9KLEAMDXW/LCboNUXmHTFoVNMz0GAECWSNLJEwAAVEPYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEorqw69y5835HPllnowAAsC2qC7u33357/nufbbzlmb777LLLLrU8\nEgAAX0XeVu295sMPFixYUkujAACwLTzHDgAgEsIOACASwg4AIBLCDgAgEsIOACASWzgrdtX7\n1/TufeeGT5e8tzKE0Lt37y/uOXny5O07GQAAW2ULYbd2zZtTpry5ycYpU6bU1jgAAHxV1YXd\nnDlz6mwOAAC2UXVh16VLlzqbAwCAbVSjkyfmv/SX343+x8Zb/nJC/xO/d/7dj01dl66duQAA\n2EpbCLuyZS+d07tTx/37X3bjyxtvX/HWy4+MuX3wCYe03ef4FxeX1OaEAADUSHVhV1H+4THf\nPOyeKe+2+9Yxl/z0wI0vOrp48iP3/PqYHq0+efXxvnsM/KCsopbnBABgC6oLu3/9v+OeW7xm\nj/Puf/+liZf9YK+NL2q8y54nnH3JxL+/d9tpnUuWPHfyTZueOQsAQB2rLuxGj56TW69F8U1n\n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\n1/O463oed10I6XUlK1Z8urqkPL+wQeOipoVelBgA+HpLXthtkMorbNqisGmmxwAAyBJJOnkC\nAIBqCDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgI\nOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBI\nCDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCA\nSAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsA\ngEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7\nAIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgI\nOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBI\nCDsAgEgIOwCASORleoCtVr7y/ZnT//76vz9ps+vuR/X/dmFOapMdZj/x8KuflZ9xxhkZGQ8A\nIFMSFnYzfz/suAtGLy6vqPq0UYeedzxR/N29mm28zxMX/uDyBSuFHQDwdZOksPv471cddN5t\nIbdo0IVD9u/a+v1/TLr93uKzvvXN/LffPnmnRpmeDgAgw5IUdnd/75aQ0/D+19757jebhhDC\nuecP++7Nux3+4x8ccu6Adx784mOyAABfK0k6eeKOBZ823+Pm9VUXQgih7aHDn7/6gFULxn7n\nrrkZHAwAIBskKew+q6is33KnTTZ+62dPHdmi8LkLB765Zl1GpgIAyBJJCrvDiup/Muv/fVaR\n3nhjKrfJ/U9eVlH69pEn3pr+sj8JAPA1kKSw+9ngrqXLn+tx2lX/+mj1xttb9bziz4O7ffD0\njw8efufKCnUHAHxNJSns9vnF06d1b/bvh3/RvX2Ttrvs9tjSkg0XHTt66mXHdJp+y3mtW+96\n16LV1VwJAECskhR2OfVaPThr7l2/uODgvXcrX75w5br/HpzLyWt27YQ3H7jm3G/kLppf6sl2\nAMDXUZLCLoSQk9finBG3/G3Wm0tWfHrWjg3+57JU/qArfvfWolX/+fdrk58pztCAAAAZk6TX\nsauZ3Hadu7fr3D3TYwAA1LXYwq581bQOXU4MISxcuLAm+1dUVBQXF5eWllazz4IFC0IIlZWV\n22NAAIDaElvYpdPlixYtqvn+kydPHjhwYE32nD9//lcdCgCgLsQWdvmN9p05c2bN9+/du/eE\nCROqP2I3evToKVOm7LLLLts8HQBALYot7FK5jXv27Fnz/XNzcwcMGFD9PsXFxSGEnJyEnWgC\nAHzdiBUAgEgk9Yjd8oXz586dt3jZqtVrSvPqN2zSvHXnrt06tinK9FwAABmTsLBLV6wcf+PV\nt9w9dvqcxV+8tHXX/U8fPHzE8FOK8lJ1PxsAQGYlKewqyj88e7+9xry+NLdes56HDezerVOb\nFkUFBXnryspWLFn03rzZ06e+dMMlpz0w9snXZjzQNt+jzADA10uSwm7GxUeOeX3pweffPO76\nIe0bbmbyyvKl40YNHTRybJ8LBs++s1edDwgAkElJOqx12Zh5jdqcN/XWYZutuhBCTn7zM0Y8\ndEfPHd956Io6ng0AIOOSFHZvrF7baOctvDRJCKHHIa3WrpldB/MAAGSVJIXdsc0Ll8+5flF5\ntW/tVVlyz/gF9Zv2q6uhAACyRZLC7vJR/cpWTt1j/5MfnDRrdUV604vTZW9OfWxwn253LFjV\na+TITAwIAJBJSTp5ovOZD//h5b7njn500JGP5OY36di5U9uWRQUF9SrKy1YuWfjuvHeWla5L\npVK9h9w+YWi3TA8LAFDXkhR2IeQMvu25/oMev/3eccWTZ85565V5s9cft0vlFLTvtHuf3v1O\nGzzs2P3aZXZKAICMSFbYhRBCu57HXdfzuOtCSK8rWbHi09Ul5fmFDRoXNS30osQAwNdb8sJu\ng1ReYdMWhU0zPQYAQJZI0skTAABUQ9gBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELY\nAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC\n2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEA\n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\nBIcdQNZK1hGdZE1LErmP1ZkknRULAEA1hB0AQCSEHSSA5x0DUBOeYwcJ4HnHANSEsIME8Lxj\nAGrCQ7GR8FAdAOCIXSQ8VAcACLtIeKgOAPBQLABAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0A\nQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIRd9iosLNzwfwCALcrL9AB8\nqf79+0+aNOnwww/P9CAAQDIIu+yVm5vbt2/fTE8BACSGh2IBACIh7AAAIiHsAAAiIewAACIh\n7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAi\nIewAACIh7AAAIiHsAAAiIewAACKRl+kBEmPu3Ln169ffxitZu3btfffd16FDh5wcSZ0YlZWV\nb7/99q677mrVksKSJZFVS5zKysr33nvvrLPOqlevXqZnqWtz587N9AhfSthtWdVd9pxzzsn0\nIACQXe68885Mj5Ax2Vm0wm7LzjjjjHXr1pWUlGz7Vb3++utjx449+OCDO3TosO3XRt147733\nXnzxRauWIJYsiaxa4lQt2emnn969e/dMz5IBhYWFZ5xxRqan2Jw0dWj8+PEhhPHjx2d6ELaC\nVUscS5ZEVi1xLFl28lQGAIBICDsAgEgIOwCASAg7AIBICDsAgEgIOwCASAg7AIBICDsAgEgI\nOwCASAi7OlVYWLjh/ySFVUscS5ZEVi1xLFl2SqXT6UzP8DVSUVHx/PPPH3744bm5uZmehZqy\naoljyZLIqiWOJctOwg4AIBIeigUAiISwAwCIhLADAIiEsAMAiISwAwCIhLADAIiEsAMAiISw\nAwCIhLADAIiEsAMAiISwAwCIhLADAIiEsAMAiISwAwCIhLADAIiEsAMAiISwqzOVz/7+8l7d\nd2lcUL/VTt/83iU3f1RememR2Lw1Hz+w9957v7Z67eYutI7ZpXLtJ3dcft63unyjSYP8hkUt\n9zvspD9MenuTXSxZVln94d8uPuOoTq2bFdQraNZ616PO+PGU9z/7wl5WLXtVli+66Lxzr5n4\nwSabLVm2SFMnxg/dL4TQsO3epwz6bp8eO4UQmu3xvZXrKjM9F5tRfG7XEML0VWVfvMg6ZpWK\ntZ+c+c2mIYTGHfY74/s/OL7vQQU5qVQq96w/vLFhH0uWVUqWPL9bg3qpVGr3Qwae88PvH3VI\n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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    },
    {
     "data": {
      "image/png": "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\nmlz6/tpXNpQe9dWvJm0zPW1e+8eCJqfn1Pr2sT0Kt73a4/5nRhzYKFhfuvrs9TvbHHNTcTL/\nqD6nHdiyzrJF817825vlWQ1HvDjvhuOaV99mfRlh7YIBTTqOPWz42zNv7bL1ufWll1SXZaar\n+MPPrz3ygFa1c/Oa7Nf2gh/e+Ulp5c4fREpt9xm7ZDJpm+lp3eJrdvA72GmvrfjyRutLU6ve\nGj/k7J4t92mcm53XaN82fb931eR5n29zl/VlgO0+Y5dMJq0vrXjGDgAgEr55AgAgEsIOACAS\nwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAg\nEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4A\nIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg7Yqy17uW8ikTjk\nmr+nehCAb4CwAwCIhLADAIiEsAMAiISwA9i5TUtfun7g6R1aNquVm1u3wT6HnXDmvRPe3fqG\nsnXv3Hjxaa2a1a9Vv2m3vhe99GnRPW0b1Wl2XqoGBvZOOakeACDdlayaeEjHs5eWJg7vc/qF\nhU2LPls8ZeLEa6ZNXDFj2Yij9g0hVBTPO6Vjj5c+Kzn0uL69CwveenlC7w6vH5O72W+xwB7m\ndx2AnXjntpuWbK644MkF4/q333KyZvbPm3a5fsyNs0a81CeEMHlwv6kri4c88sYjQ44IIVSV\nLbvq6C73zdxcu2kqxwb2Ql6KBdiJliff8sQTT9x3frvqk4YdzwshlK4qCSEkK9cPfnpJ3eZD\ntlRdCCErr8XtE25JyajAXs4zdgA70fK08y8OIVlZ/OF773+wZMmSDxZPm3h/9dXilWNWlVe2\n6zlw64fUa3Vl49yrN+/xUYG9nLAD2ImK4vnDrxx2/+9e/LysMpGV27ywXZduPUP4YMvV8pL5\nIYQ6bep85TGJnP3zc+bv8VGBvZyXYgF24uajjr1t9F96XT1y+uxFm0pLl30wb9LYu6uvZuft\nF0IoWlL01QdVfVJWuWfHBBB2ADtUUTz3Z3PWNGx719N3Xn1M57a1cxIhhKryVdU31N7nolpZ\niRVTx239qKLlv/lM2AF7nLAD2KFETlYiUVG8sCL5xUFV+ar7hp4dQgihMoSQnd/6kVNab1r+\n4NDRs7684bMfn+ObJ4AU8B47gPDxpBvP+6RxjcOc/FbjfntPTkGH247Z98bpD7c/fu35PTuV\nrFw8/blnlhX2a53/3oqlt464d82NV112wVOTnzzkqAcGHfHm6O90KSyYOXXSkvoXHlLn0Q9y\n6qXkpwPstRLJZHLndwFEatnLfVv2/NN2L+XWPqisaG4IobL0oxFXDXtswtRPN2Z3PPSwnmdf\nedf150y/5Zxz7p5Y2eCQDctnhhAqSz/+nyuG/f6Flz/cmHv8GZc9/NDwrvXyKva7af3Sn+7R\nnw+wdxN2ALvr7ddeLc1q0uPI9tUnFcXv5tY5pFWv5z9+sW8KBwP2Nt5jB7C7nvzuKccc033W\npvLqk7ce+EEIoefwLqkbCtgbecYOYHctf/lHhSfent/66O9fclrLBrmLZv7pwSdfbND1yk/f\n/HVeItXDAXsTYQfwDfjwr4/ccPujf5+7YNn6iub7H3TKuZf89MeXN8/zqgiwRwk7AIBI+GoS\nACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLC\nDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACASwg4AIBLCDgAgEsIOACAS\nwg4AIBLCDgAgEv8P6pUs+KXuSl8AAAAASUVORK5CYII="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Load required packages\n",
    "library(tseries)\n",
    "\n",
    "# ACF plot\n",
    "acf(log_returns)\n",
    "\n",
    "# PACF plot\n",
    "pacf(log_returns)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7d3c333f",
   "metadata": {
    "papermill": {
     "duration": 0.007247,
     "end_time": "2023-05-28T17:03:27.701948",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.694701",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Using the Ljung Box check the serial Correlation"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "16644637",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:27.719285Z",
     "iopub.status.busy": "2023-05-28T17:03:27.717967Z",
     "iopub.status.idle": "2023-05-28T17:03:27.738238Z",
     "shell.execute_reply": "2023-05-28T17:03:27.736337Z"
    },
    "papermill": {
     "duration": 0.031732,
     "end_time": "2023-05-28T17:03:27.740783",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.709051",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "\tBox-Ljung test\n",
      "\n",
      "data:  log_returns\n",
      "X-squared = 212.42, df = 10, p-value < 2.2e-16\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# Perform Ljung-Box test on the log returns\n",
    "ljung_box_test <- Box.test(log_returns, lag = 10, type = \"Ljung-Box\")\n",
    "\n",
    "# Print the Ljung-Box test results\n",
    "print(ljung_box_test)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9bf7bb0c",
   "metadata": {
    "papermill": {
     "duration": 0.007329,
     "end_time": "2023-05-28T17:03:27.755414",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.748085",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Based on the extremely small p-value of less than 2.2e-16, we can conclude that there is strong evidence of serial correlation in the log return data. The p-value represents the probability of obtaining the observed test statistic under the null hypothesis of no serial correlation. In this case, the p-value is practically zero, indicating that the observed test statistic is highly unlikely to occur if there is no serial correlation.\n",
    "\n",
    "Therefore, we reject the null hypothesis of no serial correlation and conclude that there is a significant presence of serial correlation in the log return data."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "10cd0f2c",
   "metadata": {
    "papermill": {
     "duration": 0.00745,
     "end_time": "2023-05-28T17:03:27.770160",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.762710",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "ARCH Effect using Ljung-Box test "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "eaaa4dc7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:27.788382Z",
     "iopub.status.busy": "2023-05-28T17:03:27.786763Z",
     "iopub.status.idle": "2023-05-28T17:03:28.167128Z",
     "shell.execute_reply": "2023-05-28T17:03:28.165288Z"
    },
    "papermill": {
     "duration": 0.392207,
     "end_time": "2023-05-28T17:03:28.169631",
     "exception": false,
     "start_time": "2023-05-28T17:03:27.777424",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      " ***** ESTIMATION WITH ANALYTICAL GRADIENT ***** \n",
      "\n",
      "\n",
      "     I     INITIAL X(I)        D(I)\n",
      "\n",
      "     1     5.568709e-05     1.000e+00\n",
      "     2     5.000000e-02     1.000e+00\n",
      "     3     5.000000e-02     1.000e+00\n",
      "\n",
      "    IT   NF      F         RELDF    PRELDF    RELDX   STPPAR   D*STEP   NPRELDF\n",
      "     0    1 -1.164e+05\n",
      "     1    7 -1.165e+05  1.12e-03  2.62e-03  1.0e-04  3.1e+12  1.0e-05  3.99e+09\n",
      "     2    8 -1.166e+05  6.24e-05  9.62e-05  9.6e-05  2.0e+00  1.0e-05  9.55e+02\n",
      "     3    9 -1.166e+05  9.00e-06  8.45e-06  9.8e-05  2.0e+00  1.0e-05  9.70e+02\n",
      "     4   17 -1.176e+05  8.77e-03  1.44e-02  5.3e-01  2.0e+00  1.1e-01  9.62e+02\n",
      "     5   18 -1.183e+05  6.22e-03  7.15e-03  3.2e-01  2.0e+00  1.1e-01  1.76e+02\n",
      "     6   20 -1.189e+05  4.81e-03  6.10e-03  2.3e-01  2.0e+00  1.1e-01  2.17e+02\n",
      "     7   22 -1.197e+05  7.13e-03  6.71e-03  1.6e-01  2.0e+00  1.1e-01  4.39e+01\n",
      "     8   24 -1.207e+05  7.48e-03  6.54e-03  1.2e-01  2.0e+00  1.1e-01  2.14e+02\n",
      "     9   26 -1.209e+05  1.91e-03  1.78e-03  2.1e-02  2.0e+00  2.3e-02  2.67e+04\n",
      "    10   28 -1.214e+05  4.29e-03  3.93e-03  4.0e-02  2.0e+00  4.5e-02  1.14e+06\n",
      "    11   30 -1.225e+05  8.61e-03  9.20e-03  7.1e-02  2.0e+00  9.0e-02  1.47e+08\n",
      "    12   32 -1.228e+05  2.52e-03  8.12e-03  6.6e-03  2.0e+00  9.0e-03  9.61e+02\n",
      "    13   35 -1.237e+05  7.31e-03  5.23e-03  2.5e-02  2.0e+00  3.6e-02  2.12e+03\n",
      "    14   37 -1.240e+05  2.97e-03  2.26e-03  4.9e-03  2.0e+00  7.2e-03  3.92e+05\n",
      "    15   39 -1.242e+05  9.74e-04  8.66e-04  9.8e-04  2.0e+00  1.4e-03  2.54e+07\n",
      "    16   40 -1.242e+05  5.98e-05  3.63e-04  9.8e-04  2.0e+00  1.4e-03  2.63e+06\n",
      "    17   41 -1.242e+05  5.84e-04  7.59e-04  9.8e-04  2.0e+00  1.4e-03  1.22e+06\n",
      "    18   45 -1.248e+05  4.33e-03  5.03e-03  1.5e-02  2.0e+00  2.3e-02  1.12e+06\n",
      "    19   53 -1.248e+05  1.38e-06  2.40e-06  1.6e-09  1.5e+04  2.3e-09  3.27e-01\n",
      "    20   54 -1.248e+05  2.55e-08  2.70e-08  1.5e-09  2.0e+00  2.3e-09  2.85e-01\n",
      "    21   67 -1.252e+05  2.98e-03  4.75e-03  2.0e-02  2.0e+00  3.2e-02  2.85e-01\n",
      "    22   68 -1.253e+05  9.31e-04  1.14e-03  1.4e-02  6.8e-01  3.2e-02  1.36e-03\n",
      "    23   70 -1.255e+05  2.04e-03  1.18e-03  4.7e-02  0.0e+00  9.3e-02  1.18e-03\n",
      "    24   72 -1.256e+05  7.48e-04  8.75e-04  1.7e-02  1.8e+00  3.4e-02  8.83e-03\n",
      "    25   74 -1.258e+05  1.80e-03  2.87e-03  6.7e-02  1.0e+00  1.4e-01  7.81e-03\n",
      "    26   75 -1.258e+05  2.87e-05  2.89e-03  1.8e-02  0.0e+00  3.8e-02  2.89e-03\n",
      "    27   76 -1.259e+05  3.47e-04  2.46e-04  1.5e-03  0.0e+00  3.4e-03  2.46e-04\n",
      "    28   77 -1.259e+05  2.82e-04  2.69e-04  1.6e-03  1.6e+00  3.4e-03  2.77e-04\n",
      "    29   78 -1.259e+05  2.91e-05  4.08e-05  1.6e-03  1.7e+00  3.4e-03  1.37e-04\n",
      "    30   80 -1.259e+05  4.07e-05  5.88e-05  5.2e-03  7.5e-01  1.2e-02  9.02e-05\n",
      "    31   81 -1.259e+05  3.97e-05  3.97e-05  2.9e-03  0.0e+00  7.0e-03  3.97e-05\n",
      "    32   82 -1.259e+05  1.61e-07  2.40e-07  7.5e-05  0.0e+00  1.7e-04  2.40e-07\n",
      "    33   83 -1.259e+05  2.12e-08  2.16e-08  5.6e-06  0.0e+00  1.4e-05  2.16e-08\n",
      "    34   84 -1.259e+05  3.99e-11  4.92e-11  3.0e-06  0.0e+00  7.3e-06  4.92e-11\n",
      "\n",
      " ***** RELATIVE FUNCTION CONVERGENCE *****\n",
      "\n",
      " FUNCTION    -1.259421e+05   RELDX        2.994e-06\n",
      " FUNC. EVALS      84         GRAD. EVALS      35\n",
      " PRELDF       4.920e-11      NPRELDF      4.920e-11\n",
      "\n",
      "     I      FINAL X(I)        D(I)          G(I)\n",
      "\n",
      "     1    1.996955e-08     1.000e+00     1.638e+02\n",
      "     2    8.619809e-02     1.000e+00     3.113e-01\n",
      "     3    9.226340e-01     1.000e+00     4.799e-01\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in garch(log_returns):\n",
      "“singular information”\n",
      "Warning message in sqrt(pred$e):\n",
      "“NaNs produced”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "\tBox-Ljung test\n",
      "\n",
      "data:  squared_residuals\n",
      "X-squared = 10.679, df = 10, p-value = 0.3831\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(forecast)\n",
    "\n",
    "# Fit an ARCH model to the log returns\n",
    "arch_model <- garch(log_returns)\n",
    "\n",
    "# Obtain the squared residuals\n",
    "squared_residuals <- arch_model$residuals^2\n",
    "\n",
    "# Perform Ljung-Box test on the squared residuals\n",
    "ljung_box_test <- Box.test(squared_residuals, lag = 10, type = \"Ljung-Box\")\n",
    "\n",
    "# Print the Ljung-Box test results\n",
    "print(ljung_box_test)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "eb660ce3",
   "metadata": {
    "papermill": {
     "duration": 0.00786,
     "end_time": "2023-05-28T17:03:28.185383",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.177523",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Based on the p-value of 0.3831 obtained from the Ljung-Box test on the squared residuals, we do not have sufficient evidence to conclude the presence of an ARCH effect in the daily log returns. The p-value is above the typical significance level of 0.05, indicating that we fail to reject the null hypothesis of no ARCH effect. \n",
    "\n",
    "Therefore, based on the given p-value, we do not have significant evidence to suggest the presence of autocorrelation in the squared residuals and, consequently, no ARCH effect in the daily log returns."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "d6788093",
   "metadata": {
    "papermill": {
     "duration": 0.007681,
     "end_time": "2023-05-28T17:03:28.200722",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.193041",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "ARCH effect using the Lagrange Multiplier (LM) test "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "5e636c7c",
   "metadata": {
    "papermill": {
     "duration": 0.00772,
     "end_time": "2023-05-28T17:03:28.216065",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.208345",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": []
  },
  {
   "cell_type": "markdown",
   "id": "4e020ea4",
   "metadata": {
    "papermill": {
     "duration": 0.007765,
     "end_time": "2023-05-28T17:03:28.231507",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.223742",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    " Details about Analysis of Variance (ANOVA)table"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "dfa4514e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:28.250461Z",
     "iopub.status.busy": "2023-05-28T17:03:28.248922Z",
     "iopub.status.idle": "2023-05-28T17:03:28.313555Z",
     "shell.execute_reply": "2023-05-28T17:03:28.310431Z"
    },
    "papermill": {
     "duration": 0.078268,
     "end_time": "2023-05-28T17:03:28.317424",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.239156",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/plain": [
       "               Df Sum Sq   Mean Sq F value Pr(>F)\n",
       "Residuals   26499   1.64 6.187e-05               "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# Convert 'log_returns' to a numeric vector\n",
    "log_returns <- as.numeric(unlist(log_returns))\n",
    "\n",
    "# Create a data frame with 'log_returns' as a single column\n",
    "data <- data.frame(log_returns)\n",
    "\n",
    "# Perform one-way ANOVA\n",
    "model <- aov(log_returns ~ 1, data = data)\n",
    "\n",
    "# Print the ANOVA table\n",
    "anova_table <- summary(model)\n",
    "summary(model)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "eb5248c5",
   "metadata": {
    "papermill": {
     "duration": 0.015793,
     "end_time": "2023-05-28T17:03:28.349365",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.333572",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Checking for Normality"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "43fd7d6e",
   "metadata": {
    "papermill": {
     "duration": 0.016146,
     "end_time": "2023-05-28T17:03:28.381294",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.365148",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "\n",
    "Jarque-Bera Test"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "cd79026f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:28.419675Z",
     "iopub.status.busy": "2023-05-28T17:03:28.416429Z",
     "iopub.status.idle": "2023-05-28T17:03:28.440289Z",
     "shell.execute_reply": "2023-05-28T17:03:28.438592Z"
    },
    "papermill": {
     "duration": 0.045318,
     "end_time": "2023-05-28T17:03:28.442778",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.397460",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "\tJarque Bera Test\n",
      "\n",
      "data:  log_returns\n",
      "X-squared = 331092, df = 2, p-value < 2.2e-16\n",
      "\n"
     ]
    }
   ],
   "source": [
    "\n",
    "# Perform the Jarque-Bera test\n",
    "jarque_bera <- jarque.bera.test(log_returns)\n",
    "\n",
    "# Print the Jarque-Bera test results\n",
    "print(jarque_bera)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "72916656",
   "metadata": {
    "papermill": {
     "duration": 0.008186,
     "end_time": "2023-05-28T17:03:28.459297",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.451111",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Based on the results of the Jarque-Bera test for your data (log_returns), the test statistic (X-squared) is 331092 with 2 degrees of freedom. The associated p-value is extremely small (less than 2.2e-16), indicating strong evidence against the null hypothesis of normality.\n",
    "\n",
    "We conclude that the distribution of log_returns is significantly different from a normal distribution. Hence the data does not follow a normal distribution."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f1a7be89",
   "metadata": {
    "papermill": {
     "duration": 0.007826,
     "end_time": "2023-05-28T17:03:28.475252",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.467426",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Shapiro-Wilk Test"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9eba53fc",
   "metadata": {
    "papermill": {
     "duration": 0.007913,
     "end_time": "2023-05-28T17:03:28.491395",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.483482",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Information Criterion statistics"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "8b8c18c0",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-05-28T17:03:28.511095Z",
     "iopub.status.busy": "2023-05-28T17:03:28.509459Z",
     "iopub.status.idle": "2023-05-28T17:03:35.285501Z",
     "shell.execute_reply": "2023-05-28T17:03:35.283788Z"
    },
    "papermill": {
     "duration": 6.788918,
     "end_time": "2023-05-28T17:03:35.288540",
     "exception": false,
     "start_time": "2023-05-28T17:03:28.499622",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "library(rugarch)\n",
    "\n",
    "#arch_model \n",
    "# Fit the ARCH model\n",
    "model <- ugarchspec(variance.model = list(model = \"sGARCH\"))\n",
    "fit <- ugarchfit(spec = model, data = log_returns)\n"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 14.423292,
   "end_time": "2023-05-28T17:03:35.417500",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2023-05-28T17:03:20.994208",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
