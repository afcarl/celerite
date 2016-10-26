using PyPlot
# Set up a time grid for the plot:
ntime = 10000
time = collect(linspace(0,4pi,ntime))

# exp-sine-squared:
x1 = [0.24998970200450718,0.7528029456942368,0.9604772168743339,0.6433934213976025]
x2 = [0.4508506501130407,-0.44533765457178637,1.0810460905919905,1.1810193449724977]
x3 = [0.20659251082649457,-0.20736062231716337,1.659019056376522,0.21064077694469815]
x4 = [0.07284486969656653,-0.0729380659597069,2.431485661375288,0.047122405324731394]
x5 = [0.019204025483424515,-0.01921291003735305,3.2797651575680282,0.011419793258824862]

gamma = 1.0
model_expsin2_g1=zeros(ntime)
model_expsin2_g1 += x1[1]+x1[2].*exp(-gamma.^x1[3].*x1[4])
model_expsin2_g1 += (x2[1]+x2[2].*exp(-gamma.^x2[3].*x2[4])).*cos(2.*time)
model_expsin2_g1 += (x3[1]+x3[2].*exp(-gamma.^x3[3].*x3[4])).*cos(4.*time)
model_expsin2_g1 += (x4[1]+x4[2].*exp(-gamma.^x4[3].*x4[4])).*cos(6.*time)
model_expsin2_g1 += (x5[1]+x5[2].*exp(-gamma.^x5[3].*x5[4])).*cos(8.*time)
expsin2_g1 = exp(-gamma.*sin(time).^2)

gamma = 3.0
model_expsin2_g3=zeros(ntime)
model_expsin2_g3 += x1[1]+x1[2].*exp(-gamma.^x1[3].*x1[4])
model_expsin2_g3 += (x2[1]+x2[2].*exp(-gamma.^x2[3].*x2[4])).*cos(2.*time)
model_expsin2_g3 += (x3[1]+x3[2].*exp(-gamma.^x3[3].*x3[4])).*cos(4.*time)
model_expsin2_g3 += (x4[1]+x4[2].*exp(-gamma.^x4[3].*x4[4])).*cos(6.*time)
model_expsin2_g3 += (x5[1]+x5[2].*exp(-gamma.^x5[3].*x5[4])).*cos(8.*time)
expsin2_g3 = exp(-gamma.*sin(time).^2)

# Gaussian (squared-exponential):
abest=[2.7518074963750734,1.5312499407621147,-0.34148888178746056,-0.3546256365636662,4.753504292338284,2.042571639590954,-1.3968344706386124,1.7967431129812566,-1.7641684073510928]
gaussian=exp(-time.^2/2.)
nexp = 3

model_gaussian = zeros(ntime)
for k=1:nexp
  model_gaussian += abest[1+(k-1)*3].*exp(-abest[2+(k-1)*3].*time).*cos(abest[3+(k-1)*3].*time)
end

# Matern 5/2:
matern52=(1.0+sqrt(5.).*time+5.*time.^2./3.).*exp(-sqrt(5.).*time)
nexp = 4
atrial = [-147.6965573,1.0097610,85.8875034,1.0621734,-4.6540017,0.8353745,67.4630744,0.9160394]
model_52 = zeros(ntime)
for k=1:nexp
  model_52 += atrial[1+(k-1)*2].*exp(-atrial[2+(k-1)*2].*sqrt(5.)*time)
end

fix,axes = subplots(2,2)
#fix,ax = subplots()

ax = axes[1]
ax[:set_title]("(a). Simple, exact kernels")
ax[:plot](time,1.+0.*time,alpha=0.5,label=L"$1$",linewidth=4,color="black")
ax[:plot](time,exp(-time/3),alpha=0.5,label=L"$e^{-t/3}$",linewidth=4,color="c")
ax[:plot](time,cos(time),alpha=1.0,alpha=0.5,label=L"$\cos{(t)}$",color="olive",linewidth=4)
ax[:plot](time,exp(-time./3).*cos(time),alpha=1.0,alpha=0.5,label=L"$e^{-t/3}\cos{(t)}$",color="coral",linewidth=4)
ax[:legend](loc="lower center",fontsize=10)
ax[:set_xlabel]("Time")
ax[:set_ylabel]("Dimensional ACF")
ax[:axis]([0,4pi,-1.1,1.1])

ax = axes[3]
ax[:set_title]("(b). Gaussian")
ax[:plot](time,gaussian,alpha=0.25,label=L"$G(z)$, exact",linewidth=4,color="fuchsia")
ax[:plot](time,model_gaussian,alpha=1.0,ls="dashed",alpha=0.5,label=L"$G(z)$, approx",color="r",linewidth=4)
ax[:legend](loc="upper right")
ax[:set_xlabel]("Time")
ax[:set_ylabel]("Dimensional ACF")
ax[:axis]([0,pi,0,1.1])

ax = axes[2]
ax[:plot](time,expsin2_g1,alpha=0.25,label=L"$E(w,1)$, exact",linewidth=4,color="b")
ax[:plot](time,model_expsin2_g1,alpha=1.0,label=L"$E(w,1)$, approx",ls="dashed",alpha=0.5,color="b",linewidth=4)
ax[:plot](time,expsin2_g3,alpha=0.25,label=L"$E(w,3)$, exact",linewidth=4,color="g")
ax[:plot](time,model_expsin2_g3,alpha=1.0,label=L"$E(w,3)$, approx",ls="dashed",alpha=0.5,color="g",linewidth=4)
ax[:set_title]("(c). Exp-sine-squared")
ax[:legend](loc="upper center",fontsize=10)
ax[:set_xlabel]("Time")
ax[:set_ylabel]("Dimensional ACF")
ax[:axis]([0,pi,0,1.1])

ax = axes[4]
matern32 = (1.+sqrt(3.).*time).*exp(-sqrt(3.).*time)
b = 100.
model_32 = (1-b)*exp(-sqrt(3.).*time)+b*exp(-(b-1)/b.*sqrt(3.).*time)
ax[:plot](time,matern32,alpha=0.25,label=L"$K_{3/2}(t)$, exact",linewidth=4,color="goldenrod")
ax[:plot](time,model_32,alpha=1.0, label=L"$K_{3/2}(t)$, approx",ls="dashed",alpha=0.5,color="saddlebrown",linewidth=4)
ax[:plot](time,matern52,alpha=0.25,label=L"$K_{5/2}(t)$, exact",linewidth=4,color="m")
ax[:plot](time,model_52,alpha=1.0, label=L"$K_{5/2}(t)$, approx",ls="dashed",alpha=0.5,color="indigo",linewidth=4)
ax[:set_title]("(d). Matern")
ax[:legend](loc="upper right")
ax[:set_xlabel]("Time")
ax[:set_ylabel]("Dimensional ACF")
ax[:axis]([0,pi,0,1.1])
