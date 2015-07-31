# 
# Test the split parsed function free enery Cahn-Hilliard Bulk kernel
# The free energy used here has the same functional form as the SplitCHPoly kernel
# If everything works, the output of this test should replicate the output
# of marmot/tests/chpoly_test/CHPoly_Cu_Split_test.i (exodiff match)
# 

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  nz = 0
  xmin = 0
  xmax = 250
  ymin = 0
  ymax = 250
  zmin = 0
  zmax = 0
  elem_type = QUAD4
[]

[Variables]
  [./c]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = SmoothCircleIC
      x1 = 100.0
      y1 = 150.0
      radius = 60.0
      invalue = 1.0
      outvalue = 0.1
      int_width = 30.0
    [../]
  [../]
  [./w]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./c_res]
    type = SplitCHParsed
    variable = c
    f_name = F
    kappa_name = kappa_c
    w = w
  [../]
  [./w_res]
    type = SplitCHWRes
    variable = w
    mob_name = M
  [../]
  [./time]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]
[]

[Materials]
  [./pfmobility]
    type = PFMobility
    block = 0
    kappa = 0.1
    mob = 1e-3
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    block = 0
    f_name = F
    args = c
    constant_names = 'barr_height  cv_eq'
    constant_expressions = '0.1          1.0e-2'
    function = 16*barr_height*(c-cv_eq)^2*(1-cv_eq-c)^2
    derivative_order = 2
  [../]
[]

[AuxVariables]
  [./eta0]
  [../]
[]

[ICs]
  [./eta0]
    type = SmoothCircleIC
    x1 = 100.0
    y1 = 150.0
    radius = 60.0
    invalue = 1.0
    outvalue = 0.0
    int_width = 30.0
    variable = eta0
  [../]
[]

[VectorPostprocessors]
  [./centers]
    type = GrainCentersPostprocessor
    grain_data = grain_center
  [../]
  [./force]
    type = ConstantGrainForcesPostprocessor
    grain_force = grain_force
  [../]
[]

[UserObjects]
  [./grain_center]
    type = ComputeGrainCenterUserObject
    etas = eta0
    execute_on = 'initial linear'
  [../]
  [./grain_force]
    type = ConstantGrainForceAndTorque
    force = '0.5 0.5 0.0'
    grain_data = grain_center
  [../]
[]

[Preconditioning]
  # active = ' '
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = -pc_type
  petsc_options_value = lu
  l_max_its = 30
  l_tol = 1.0e-4
  nl_rel_tol = 1.0e-10
  start_time = 0.0
  num_steps = 2
  dt = 1
[]

[Outputs]
  output_initial = true
  interval = 1
  exodus = true
  csv = true
  print_perf_log = true
[]

