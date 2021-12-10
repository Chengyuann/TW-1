import numpy as np
from matplotlib import pyplot as plt

def gacc(y):
    return G*mars_mass/(y**2)


def dens(y):
    if y>7000:
        temp=249.5-2.22*(y/1000)
        pressure= 700*np.exp(-0.09*(y/1000))
    if y<=7000:
        temp= 241-0.999*(y/1000)
        pressure= 700*np.exp(-0.09*(y/1000))
    return pressure/(9188.95110711075*temp)


mars_mass= 6.39*(10**23)
G= 6.67*(10**(-11))
mars_radius= 3.39 * (10**9)
y0= 12500*(10**3) + mars_radius
v0= -975
yAcc= 0
yVel= v0
y=y0
m=1285
t=0

ydata= []
yVeldata= []
yAccdata= []
time= []
density= []
gdata= []
dragdata= []

delta_t= 0.01
i=0
while t>=0:
    if y<=mars_radius:
        break
    t=i*delta_t
    time.append(t)
    if yVel<-460:
        g=gacc(y)
        rho=dens(y)
        A= 12.56
        Cd= 1.05
        drag=A/2*Cd*rho*(yVel**2)
        yAcc=(drag - m*g)/m
        yVel += yAcc*delta_t
        y += yVel*delta_t
    else:
        if yVel<-95:
            g=g(y)
            rho=rho(y)
            A= 200
            Cd= 0.43
            drag=A/2*Cd*rho*(yVel**2)
            yAcc=(drag - m*g)/m
            yVel += yAcc*delta_t
            y += yVel*delta_t
        else:
            if yVel<-3.6:
                g=g(y)
                rho=rho(y)
                A= 12.56
                Cd= 1.05
                drag=A/2*Cd*rho*(yVel**2)+5000
                yAcc=(drag - m*g)/m
                yVel += yAcc*delta_t
                y += yVel*delta_t
            else:
                yAcc=0
                yVel=-3.6
                y += yVel*delta_t
    time.append(t)
    ydata.append(y)
    yVeldata.append(yVel)
    yAccdata.append(yAcc)
    gdata.append(g)
    density.append(rho)
    dragdata.append(drag)
    i+=1

s= 0.001
impactForce= 1/2*m*(yVeldata[-1]**2)/s
impactStress= impactForce/0.01

if impactStress <= 276*(10**2):
    print('着陆成功')
else:
    print('着陆失败')
    print(time[-1])
    print(ydata[-1]-mars_radius)
    print(yVeldata[-1])
'''
acc=[]
v=[]
height=[]
kl=[]
for k in range(0,len(yAccdata),100):
    kl.append(k)
    acc.append(yAccdata[k])
    v.append(yVeldata[k])
    height.append(ydata[k])
plt.plot(kl,acc,"C1",label="acc")
plt.show()
plt.plot(kl,v,"C2",label="vel")
plt.show()
plt.plot(kl,height,"C3",label="y")
plt.show()
'''