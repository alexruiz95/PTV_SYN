import numpy as np 
from matplotlib import pyplot as plt 
import matplotlib.patches as mpatches
import os,sys 

# files=os.listdir('img')
# num_files = len(files)
# print(num_files)
case = sys.argv[1]
start = int(sys.argv[2])
end = int(sys.argv[3])
k=np.empty((5,1+end-start))
frame = np.array(range(start,end))

for j in range(0,4):
	# kk=np.append(kk,[k])
	m=0
	for i in range(start,end):
		m=m+1
		# data = np.loadtxt("img"+str(j)+"/cam"+str(j+1)+".0"+str(i)+"_targets",skiprows=1)
		f = open(case+"/img/Cam"+str(j+1)+"/frame_100"+str(i)+"_targets")
		lines = f.readlines()
		data = lines[0]
		k[j,m]=data
		# k=np.appen

m=0
for i in range(start,end):
	m=m+1
	# data = np.loadtxt("img"+str(i)+"/cam"+str(j+1)+".0"+str(i)+"_targets",skiprows=1)
	f2 = open(case+"/res/rt_is."+str(i))
	lines2 = f2.readlines()
	data2 = lines2[0]
	k[4,m]=data2
plt.figure(figsize=[12, 5])
plt.figure(1)
plt.subplot(131)
plt.plot(frame,k[4,1:], label= 'rt_is')
plt.legend(['rt_is'])
plt.title('Number of particles per frame')
plt.subplot(132)
plt.plot(frame,k[0,1:], label= 'cam1')
plt.plot(frame,k[1,1:], label= 'cam2')
plt.plot(frame,k[2,1:], label= 'cam1')
plt.plot(frame,k[3,1:], label= 'cam2')
plt.legend(['cam1', 'cam2','cam3','cam4'])
plt.title('Number of targets per frame')
plt.subplot(133)
plt.plot(np.ediff1d(k[4,1:]), label = 'diff of rt_is')
plt.title('diff rt_is')
plt.tight_layout()
plt.show()