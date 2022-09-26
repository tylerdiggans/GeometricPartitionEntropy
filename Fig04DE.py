import random, argparse, warnings, struct, io
import numpy as np
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
from PIL import Image, ImageDraw
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.patches import FancyArrowPatch
from mpl_toolkits.mplot3d import proj3d
from multiprocessing import Pool, cpu_count
from scipy.integrate import odeint
from scipy.spatial.distance import pdist
from matplotlib.ticker import (MultipleLocator, FormatStrFormatter,
							   AutoMinorLocator)
def get_input():
	parser = argparse.ArgumentParser()
	
	#------------------Model Parameters----------------------------
	parser.add_argument('--States', default=None, 
						help='txt filename containing an adjacency matrix \
								saved using pandas.to_csv()')
	parser.add_argument('--Positions', default=None, 
						help='txt filename containing positions for embedding')

#------------------Plotting Parameters----------------------------
	parser.add_argument('--plotting', default=True, 
						help='Used to suppress plotting functionality')
#------------------Saving Parameters----------------------------
	parser.add_argument('--saving', default=False, 
						help='Used to save positions file')
	parser.add_argument('--pathname', default='./', 
						help='filename for saving adjacency matrix as txt')
	parser.add_argument('--filename', default='Positions.txt', 
						help='filename for saving adjacency matrix as txt')
	args = parser.parse_args()
	return args         


def process_input(args):
# An adjacency matrix must be supplied
	# H = np.genfromtxt('Hist_Matrix_k_'+str(args.States)+'.txt', delimiter=',')
	# Q = np.genfromtxt('Quan_Matrix_k_'+str(args.States)+'.txt', delimiter=',')
	H = np.genfromtxt('WHist.txt', delimiter=',')
	Q = np.genfromtxt('WQuant.txt', delimiter=',')

	if not args.Positions:
		X = None
	else:
		X = np.loadtxt(args.Positions)
	N = np.shape(H)[0]
	savefile = "".join([str(args.pathname), str(args.filename)])
	return N, H, Q, X, savefile, args.plotting, args.saving


class Arrow3D(FancyArrowPatch):
	def __init__(self, xs, ys, zs, *args, **kwargs):
		FancyArrowPatch.__init__(self, (0,0), (0,0), *args, **kwargs)
		self._verts3d = xs, ys, zs

	def draw(self, renderer):
		xs3d, ys3d, zs3d = self._verts3d
		xs, ys, zs = proj3d.proj_transform(xs3d, ys3d, zs3d, renderer.M)
		self.set_positions((xs[0],ys[0]),(xs[1],ys[1]))
		FancyArrowPatch.draw(self, renderer)


if __name__=='__main__':
	plt.rcParams.update({'font.size': 20,
		'font.family': 'Times New Roman'
		})
	args = get_input()
	N, H, Q, X, savefile, plotting, saving = process_input(args)

	DH = [sum(H[row,:]) for row in range(N)]
	DQ = [sum(Q[row,:]) for row in range(N)]
	for n in range(N):
		if  DH[n]!= 0:
			DH[n] = 1/DH[n]
		if  DQ[n]!= 0:
			DQ[n] = 1/DQ[n]
	H = np.dot(np.diag(DH),H)
	Q = np.dot(np.diag(DQ),Q)

	cm = plt.get_cmap('binary')

	fig = plt.figure()
	ax = fig.add_subplot(111)
	h = ax.pcolor(H, cmap=cm)
	ax.grid(linewidth=0.25)
	ax.set_xticks(range(25))
	ax.set_yticks(range(25))
	ax.invert_yaxis()
	cbar = plt.colorbar(h, ax=ax, ticks=[0,0.5,1])
	ax.xaxis.tick_top()
	#Set x axis lable to top
	ax.xaxis.set_label_position('top') 
	ax.xaxis.set_major_locator(MultipleLocator(5))
	ax.yaxis.set_major_locator(MultipleLocator(5))
	ax.set_aspect('equal')

	fig2 = plt.figure()
	ax2 = fig2.add_subplot(111)
	h = ax2.pcolor(Q, cmap=cm)
	ax2.grid(linewidth=0.25)
	ax2.set_xticks(range(25))
	ax2.set_yticks(range(25))
	ax2.invert_yaxis()
	cbar = plt.colorbar(h, ax=ax2, ticks=[0,0.5,1])
	ax2.xaxis.tick_top()
	#Set x axis lable to top
	ax2.xaxis.set_label_position('top') 
	ax2.xaxis.set_major_locator(MultipleLocator(5))
	ax2.yaxis.set_major_locator(MultipleLocator(5))
	ax2.set_aspect('equal')
	plt.show()

	if saving:
		np.savetxt(savefile, X)