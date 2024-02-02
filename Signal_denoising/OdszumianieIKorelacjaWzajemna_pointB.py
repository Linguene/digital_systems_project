import numpy as np

from skimage.restoration import denoise_wavelet
import matplotlib.pyplot as plt
import pywt
import pywt.data
from scipy.io import wavfile
import numpy as np
from skimage.restoration import denoise_wavelet
import matplotlib.pyplot as plt
from scipy import signal
import numpy as np
import matplotlib.pyplot as plt
file_a=[]
file_b=[]

#PointA.wav
x = np.loadtxt('pointb.txt', dtype=float)

print("xA przed normalizacją:",x)
x = x/max(x)
print("xA po normalizacji",x)
x_noisy = x    # Adding noise to signal

# Wavelet denoising
x_denoise = denoise_wavelet(x_noisy, method='VisuShrink', mode='soft', wavelet_levels=3, wavelet='sym8', rescale_sigma='True')
plt.figure(figsize=(9, 4), dpi=100)
plt.plot(x_noisy)
plt.plot(x_denoise)
plt.xlabel("x signal B")
plt.ylabel("y signal B")


#PointB.wav
#Fsb, xb = wavfile.read('PointB_signal8.wav')
#print("FsB",Fsb)
#print("xB przed normalizacją:",xb)
xb = np.loadtxt("sent.txt", dtype=float)
print(xb)
xb = xb/max(xb) #Normalizing amplitude
print("xB po normalizacji",xb)
sigma = 0.05  # Noise variance
x_noisyb = xb   # Adding noise to signal
# Wavelet denoising
x_denoiseb = denoise_wavelet(x_noisyb, method='VisuShrink', mode='soft', wavelet_levels=3, wavelet='sym8', rescale_sigma='True')
plt.figure(figsize=(9, 4), dpi=100)
plt.plot(x_noisyb)
plt.plot(x_denoiseb)
plt.xlabel("x signal sent")
plt.ylabel("y signal sent")
plt.show()


#wrzucamy wartosci z nd array x do listy a
for i in x:
    file_a.append(i)
#wrzucamy wartosci z nd array xb do listy b
for j in xb:
    file_b.append(j)

C = signal.correlate(file_a, file_b)
print()
print("Sygnał skorelowany (default):",C)

print('Przesunięcie (default) =', np.argmax(C) - (len(file_b) - 1))
plt.plot(np.arange(len(C)) - (len(file_b) - 1), C)
plt.axvline(0, lw=1, c='k')
plt.xlabel('opóźnienie')
plt.ylabel('korelacja')

file_aD=[]
file_bD=[]

#wrzucamy wartosci z nd array x do listy a
for i in x_denoise:
    file_aD.append(i)
#wrzucamy wartosci z nd array xb do listy b
for j in x_denoiseb:
    file_bD.append(j)
print(file_bD)
D = signal.correlate(file_aD, file_bD)
print()
print("Sygnał skorelowany (po odszumieniu):",D)
print('Przesunięcie(po odszumieniu) pointb-sent =', np.argmax(D) - (len(file_bD) - 1))

plt.show()

