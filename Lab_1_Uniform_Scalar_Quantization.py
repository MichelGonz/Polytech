import numpy as np
import math
import matplotlib.pyplot as plt
from PIL import Image


def delta(Smax, Smin, R):
    L = 2 ** R
    return (Smax-Smin)/L


def Q(s, Smin, D):
    return math.floor((s-Smin)/D + 0.5) * D + Smin


def scalar_quantizer(Signal, Smin, D):
    S = [np.array([Q(s, Smin, D)]) for s in Signal]
    return S


def imgsave(i, l, h, SignalFin, R):
    # create a new img
    res = Image.new("L", (l, h))
    # fill the img
    res.putdata(SignalFin)
    # save the file with his name
    res.save(str(R) + '_' + i)


def quantizer_algorithm(Signal, R):
    Max = np.max(Signal)
    Min = np.min(Signal)
    Delta = delta(Max, Min, R)
    return scalar_quantizer(Signal, Min, Delta)


def plot_img(i, R):
    # open image
    image = Image.open(i)
    # transform img to signal
    Signal = image.getdata()
    # get size of img
    l, h = image.size

    # Quantizer algorithm
    SignalFin = quantizer_algorithm(Signal, R)

    # saving image
    imgsave(i, l, h, SignalFin, R)


def plot(Sign, x):
    Signal = Sign(x)

    SignalFin = quantizer_algorithm(Signal, 3)

    # plot
    plt.plot(Signal)
    plt.plot(SignalFin)
    arg = ["Sine", "Sine with scalar quantizer"]
    plt.legend(arg)
    plt.show()


def D_distorsion(R):
    image = Image.open('lena512.bmp')
    Signal = image.getdata()
    N = len(Signal)
    SignalFin = quantizer_algorithm(Signal, R)

    return (1.0/N) * sum([abs((Signal[n] - SignalFin[n])) ** 2 for n in range(1, N)])


def distorsion():
    return [D_distorsion(i) for i in range(1, 8)]


def plot_distorsion():
    plt.plot(distorsion())
    arg = ["Distorsion of quantization"]
    plt.legend(arg)
    plt.show()


def getHistogram(imageList):
    hist = []
    for i in range(256):
        hist.append(0)
        for j in imageList:
            if j == i:
                hist[i] += 1
    return hist


def countColor(Signal):
    count = 0
    for hi in getHistogram(Signal):
        if hi != 0:
            count += 1
    return count


def H(Signal):
    # to calcul Pi(x)
    count = countColor(Signal)
    entropy = 0
    for hi in getHistogram(Signal):
        if hi != 0:
            # Pi(x) * log(Pi(x))
            entropy += (hi/count) * math.log(float(hi)/count, 2)
    return entropy


def d_H(Signal):
    arr = []
    for i in range(1, 8):
        arr.append(H(quantizer_algorithm(Signal, i)))
    return arr


def plot_shannon_entropy():
    image = Image.open('lena512.bmp')
    Signal = image.getdata()

    # plot
    plt.plot(d_H(Signal))
    arg = ["Shannon entropy"]
    plt.legend(arg)
    plt.show()


def D_psnr(R):
    image = Image.open('lena512.bmp')
    Signal = image.getdata()
    N = len(Signal)
    SignalFin = quantizer_algorithm(Signal, R)

    return 10 * math.log(255**2/((1.0/N) * sum([abs((Signal[n] - SignalFin[n])) ** 2 for n in range(1, N)])), 10)


def psnr():
    return [D_psnr(i) for i in range(1, 8)]


def plot_psnr():
    plt.plot(psnr())
    arg = ["PSNR"]
    plt.legend(arg)
    plt.show()


def main():
    ###############Plot sin######################
    #plot(np.sin, np.linspace(-np.pi, np.pi, 201))
    #############################################

    ###############Lena scalar quantizer#########
    #for i in range(1, 8):
    #    plot_img('lena512.bmp', i)
    #############################################

    ###############MSE plot######################
    #plot_distorsion()
    #############################################

    ###############Shannon Entropy ##############
    #plot_shannon_entropy()
    #############################################

    ###############PSNR##########################
    #plot_psnr()
    #############################################
    return 0


main()

