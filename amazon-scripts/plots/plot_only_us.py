#!/usr/bin/env python2

import numpy as np
import scipy.stats as st
import matplotlib.pyplot as plt
from parse_results import parse_results
import os
import os.path as path

qws = [ (1000,0),
        (5000,0),
        (10000,0),
        (1000,100),
        (5000,100),
        (10000,100) ]

def flatten_vals(r):
    bars = [0] * 6
    yerr = [0] * 6

    for idx, (q,w) in enumerate(qws):
        vs        = next(x['values'] for x in r if (x['q'] == q and x['w'] == w))
        bars[idx] = np.mean(vs)
        yerr[idx] = st.sem(vs)

    return (bars,yerr)


def get_vals_and_errs():
    this_dir   = path.dirname(path.realpath(__file__))

    gochai_log = path.join(this_dir, '..', 'logs', '20180705_1740_gochai_batched.txt')

    gochai_vs = parse_results(gochai_log)

    (bars1, yerr1) = flatten_vals(gochai_vs)

    return (bars1,yerr1)

def barplot_default():   
    res = get_vals_and_errs()
    (bars1,yerr1) = res

    print res

    # plt.rc('text', usetex=True) # enable latex in labels

    # input data
    bar_labels = map(lambda n: str(n[0]), qws)


    fig = plt.figure(figsize=(6,4))
    ax = plt.subplot(111)
    
    # plot bars
    plot_bar_width = 0.3

    n = len(bars1) / 2
    x_pos1 = [1,1.5,2,3,3.5,4]

    def call_bar(*args, **kwargs):
        common_opts = {
                "ecolor"    : 'black',
                "linewidth" : 0.5,
                "alpha"     : 0.5,
                "edgecolor" : 'black',
                "align"     : 'center',
                "capsize"   : 3,
                "width"     : plot_bar_width
                }
        common_opts.update(kwargs)
        plt.bar(*args, **common_opts)


    call_bar(x_pos1, bars1, yerr=yerr1, color='lightblue')

    # set height of the y-axis
    max_y = max(zip(bars1, yerr1)) # returns a tuple, here: (3, 5)
    plt.ylim([0, (int(max_y[0]) + int(max_y[1])) * 1.05])

    # hiding axis ticks
    plt.tick_params(axis="both", which="both", bottom=False, top=False,  
            labelbottom=True, left=False, right=False, labelleft=True)

    # adding horizontal grid lines 
    ax.yaxis.grid(color='k', linestyle=':', linewidth=0.5) 
    
    # remove axis spines
    ax.spines["top"].set_visible(False)  
    ax.spines["right"].set_visible(False) 
    # ax.spines["bottom"].set_visible(False) 
    ax.spines["left"].set_visible(False)

    # set axes labels and title
    plt.ylabel('throughput (req/ms)', fontsize=14)
    tick_pos = [x for x in x_pos1]
    plt.xticks(tick_pos, bar_labels, fontsize=12)

    # manual grid ticks
    ytick_dist = 20
    ax.set_yticks(range(ytick_dist, int(max_y[0])+ytick_dist*2,ytick_dist))
    
    # plt.text(1, max_y[0] + max_y[1] + 1, 'Title',
    #      horizontalalignment='center',
    #      fontsize=18)

    xlabel_dist = 0.0
    plt.text(x_pos1[1]   - xlabel_dist, -20, 'Read',  fontsize=14, horizontalalignment='center')
    plt.text(x_pos1[n+1] - xlabel_dist, -20, 'Write', fontsize=14, horizontalalignment='center')

    plt.tight_layout()
    plt.subplots_adjust(bottom=0.15)
    plt.show()


if __name__ == '__main__':
    barplot_default()
