# MBSim
The motorcycle model is based on the open source mulitbody simulation software MBSim. 
Please download the software under following link: https://www.mbsim-env.de/builds/run/current/win64-dailyrelease/. 

# Motorcycle model
In the following some information about the model functionalities are given. More details on the model 
can be found in the following paper: https://www.mdpi.com/2076-3417/10/19/6826.

### Switch for Dofs
The parameters with the name beginning in "enable_" allow to decide which Dofs are 
modelled. Set the parameter to 1 to activate the Dof, to 0 to deactivate it. 

### Contollers
There are two controllers: one for the longitudinal and one for the lateral dynamics. 
They are present in the group: `Group_Controller`. This group is then spilt in lateral
and longitudinal controller. The parameters relative to each controller are specified 
in the parameter list definied within the controller itself. 
* Lateral dynamics controller: PD controller which allows the motorcycle to reach 
a speficied roll angle. The desired roll angle can be given with the parameter `Setval_roll_angle`.
The controller receives the signals of actual roll angle and 
applies a steer moment. 
* Longitudinal dynamics controller: PID controller which allows to perform a acceleration-braking
maneuver. It acts with a drive moment on the rear wheel or with a brake moment on both wheels according to
the `Brake_distribution`. The desired speed evolution can be specified with the SignalOperation `vx_target`. 
In the present version this parameter is set in order for the motorcycle to reach a desired `v_end` 
from the inital `v0` speed describing a Cosinus function. 

### Excitations
The motorcycle stability can be tested with some excitations:
* `Torque_steer`: applies a cosinus shaped steer moment starting at `T_To_start`
and ending at `T_To_exc`.
* `Fy_Impuls`: applies a cosinus shaped lateral force to the frame starting at `T_To_start`
and ending at `T_To_exc`.
* Road weaves can be simulated by setting the following parameters: `h_road_weaves` for the height,
`l_road_weaves` for their length and `n_road_weaves`to specify the number.

# Motorcycle parameters
The only motorcycle parameters which can be directly changed in MBSim are `steering_damper`
and `caster_angle`. The other parameters, including geometry, mass-inertia, tyres and stiffnesses-damping
are present in the Excel file in the folder `Data`. In order to change one ore more parameters please execute the following steps:
* Modify the desired parameters in Excel and save the file.
* Execute the script `read_excel`. This generates five .xml files, which are read from the model.
* If the model was open, reload it.

# Troubleshooting (Windows)
The script `read_excel` is "ready to use" in Matlab. Alternatively it can be run
in the open source "Octave". In this case, the Xerces Java 2 package must be downloaded 
from https://xerces.apache.org/mirrors.cgi#binary. Then the following lines must be added
at the beginning of the script:<br />
`pkg load io`<br />
`javaaddpath ("/path/to/xerces-2_12_1/xercesImpl.jar");`<br />
`javaaddpath ("/path/to/xerces-2_12_1/xml-apis.jar");`<br />
Some errors have been encountered when executing these lines. A possible one is: `error: javaMethod: 
could not find library or dependencies: C:\Program Files\Java\OpenJDK_11.0.2\bin\jvm.dll`.
In this case the solution was to change the system varible `JAVA_HOME` so that it 
points to the folder containing the file `jvm.dll`.<br />
Another error source could result if Octave is not able to find Java (JRE). In this case
please make sure to actually have Java. If the error still remains a solution could be 
to write the following line after `pkg load io`:<br />
`pkg load windows`<br />

# FMU
MBSim provides some functionalities to produce a so-called Functional Mock-Up (FMU).
This is an interface which allows to export the MBSim model and to run it in other 
environments. The model can be exported as Co-Simulation or Model-Exchange. In the first 
case the solver in MBSim is exported together with the model; in the second case the 
solver must be provided from the environment where the model is run. Further information 
about FMU can be found in (https://fmi-standard.org/). In order to export the FMU 
from MBSim the following command must be executed from the matlab command:<br />
`system('path\to\mbsim-env\bin\mbsimCreateFMU.exe --cosim path\to\Motorcycle_FMU.mbsx')`<br />
The command `--cosim` is needed to generate a Co-Simulation. Without it a Model-Exchange
is generated.<br />
The file `Motorcycle_FMU.mbsx` is identical to the standard model, but under links there is the possibiliy to define input and outputs for the FMU. Please 
add inputs and outpus with `ExternSignalSource` and `ExternSignalSink` respectively. 
When importing the FMU for example in Simulink, the inputs and outpus will appear 
in the related box. Moreover, a suitable solver for the Co-Simulation is already set
in `Motorcycle_FMU.mbsx`.<br />
In Simulink, a bus object for the input and outputs must be created. For that, please run the simulink model containing the FMU. Simulink will throw an error and suggest to create the bus object with the command `fmudialog.createBusType()`. After that the bus object can be saved to a .mat file and loaded every time before loading the simulink model.<br />
In the directory FMU an example is present, where the FMU model of the motorcycle accepts steering moment as input and provides the roll angle as output. Please follow the configuration in the "example.slx" simulink model. In particular, a bus creator and selector are needed. In the bus creator please select the option "Output as nonvirtual bus"; this option is already selected in the example. Moreover, in the FMU itself, the name of the input and output bus should be changed, for example in "mbs_in" and "mbs_out" as in the proposed file.

# Authors
The multibody model was developed by Francesco Passigato (Chair of Automotive Technology at TU Munich) and
Dipl.-Ing. Dirk Wisselmann. A part of the rider model was created by Michael Härtl (Master Degree Student at TU Munich).
A great contribution was given by Prof. Martin Förg (University of Landshut), who helped to 
solve several problems and provided lots of suggestions on how to structure the model istelf. 

# References 
*  The model parameters are taken from: <br />
R. S. Sharp, S. A. Evangelou, and D. J. N. Limebeer, <br />
"Advances in the modelling of motorcycle dynamics",<br />
Multibody System Dynamics, vol. 12, no. 3, pp. 251-283, 2004.<br />
