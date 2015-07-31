[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  nz = 0
  xmin = 0
  xmax = 1000
  ymin = 0
  ymax = 1000
  zmin = 0
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
[]

[GlobalParams]
  op_num = 2
  var_name_base = gr
  implicit = false
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./BicrystalCircleGrainIC]
      radius = 333.333
      x = 500
      y = 500
    [../]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./PolycrystalKernel]
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./CuGrGr]
    type = CuGrGr
    block = 0
    T = 500 # K
    wGB = 60 # nm
  [../]
[]

[Postprocessors]
  [./gr1area]
    type = ElementIntegralVariablePostprocessor
    variable = gr1
    execute_on = 'initial timestep_end'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  #l_max_its = 3
  petsc_options_iname = -pc_type
  petsc_options_value = bjacobi
  type = Transient
  scheme = explicit-euler
  solve_type = NEWTON
  l_tol = 1.0e-6
  nl_rel_tol = 1.0e-6
  num_steps = 61
  dt = 0.08
[]

[Outputs]
  # csv = true
  output_initial = true
  interval = 20
  exodus = true
  output_final = true
  print_perf_log = true
[]