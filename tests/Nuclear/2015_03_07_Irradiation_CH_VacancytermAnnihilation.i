[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 200
  ny = 80
  nz = 0
  xmax = 50
  ymax = 20
  zmax = 0
[]

[Variables]
  active = 'c e'
  [./c]
    order = THIRD
    family = HERMITE
    block = 0
  [../]
  [./e]
    block = 0
  [../]
  [./phi1]
    block = 0
  [../]
  [./phi2]
    block = 0
  [../]
[]

[AuxVariables]
  [./Energy]
    order = CONSTANT
    family = MONOMIAL
    block = 0
  [../]
  [./eta0]
  [../]
  [./eta1]
  [../]
  [./R1]
  [../]
  [./R2]
  [../]
[]

[Kernels]
  [./CH_Parsed]
    type = CHParsed
    variable = c
    mob_name = D
    f_name = F
    args = e
  [../]
  [./c_dot]
    type = TimeDerivative
    variable = c
    block = 0
  [../]
  [./CH_int]
    type = CHInterface
    variable = c
    mob_name = D
    kappa_name = kappa_c
    grad_mob_name = grad_D
  [../]
  [./ACbulk]
    type = ACParsed
    variable = e
    f_name = F
    args = 'c '
    block = 0
  [../]
  [./e_dot]
    type = TimeDerivative
    variable = e
    block = 0
  [../]
  [./AC_int]
    type = ACInterface
    variable = e
    block = 0
  [../]
  [./CH_Pv]
    type = VacancySourceTermKernel
    variable = c
    c = e
    block = 0
    R2 = R2
    R1 = R1
  [../]
  [./CH_Sv]
    type = VacancyAnnihilationKernel
    variable = c
    c = e
    ceq = 1.13e-4
    v = 'eta0 eta1'
    block = 0
  [../]
  [./AC_Pv]
    type = VacancySourceTermKernel
    variable = e
    c = e
    R2 = R2
    block = 0
    R1 = R1
  [../]
[]

[AuxKernels]
  [./TotalFreeEng]
    type = TotalFreeEnergy
    variable = Energy
    interfacial_vars = 'c e'
    kappa_names = 'kappa_c kappa_op'
    block = 0
  [../]
[]

[BCs]
  [./Periodic]
    [./periodic]
      variable = 'c e '
      auto_direction = 'x y '
    [../]
  [../]
[]

[Materials]
  active = 'FreeEnergy AC_mat Mobility'
  [./FreeEnergy]
    type = DerivativeParsedMaterial
    block = 0
    constant_expressions = '1.0 8.6173324e-5 1276 1.0 1.0 1.13e-4'
    function = '(e-1)^2*(e+1)^2*(Ef*c+kb*T*(c*log(c)+(1-c)*log(1-c))) - A*(c-ceq)^2*e*(e+2)*(e-1)^2 + B*(c-1)^2*e^2'
    args = 'c e'
    constant_names = 'Ef kb T A B ceq '
    tol_values = 0.1
    tol_names = c
  [../]
  [./Mobility]
    type = TempDiffusion
    block = 0
    c = c
    kappa = 2.5e-3
    Dv = 0.64
  [../]
  [./AC_mat]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'L kappa_op S'
    prop_values = '10.0 5.0e-3 100'
  [../]
  [./energy_matrix]
    type = DerivativeParsedMaterial
    block = 0
    constant_expressions = '1.0 8.6173324e-5 1276 '
    function = ((e-1)^2)*(Ef*c+kb*T*(c*log(c)+(1-c)*log(1-c)))
    args = 'e c'
    constant_names = 'Ef kb T'
    tol_values = 0.1
    tol_names = c
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.1
  l_max_its = 30
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         31   preonly   lu      1'
  end_time = 50
  scheme = bdf2
[]

[Outputs]
  exodus = true
  show = 'c e Energy'
  tecplot = true
  output_on = 'timestep_end initial'
  [./console]
    type = Console
    perf_log = true
    fit_mode = 120
    output_file = true
    output_on = 'timestep_end nonlinear failed initial'
  [../]
[]

[ICs]
  active = 'PolycrystalICs R1 R2 const_e ConstIC'
  [./R1]
    variable = R1
    type = RandomIC
    block = 0
  [../]
  [./R2]
    variable = R2
    type = RandomIC
  [../]
  [./ConstIC]
    variable = c
    value = 0.07
    type = ConstantIC
    block = 0
  [../]
  [./const_e]
    variable = e
    value = 0.0
    type = ConstantIC
    block = 0
  [../]
  [./circle]
    x1 = 25
    y1 = 10
    radius = 7
    outvalue = 1.13e-4
    variable = c
    invalue = 0.999
    type = SmoothCircleIC
  [../]
  [./circle_e]
    x1 = 25
    y1 = 10
    radius = 7.0
    outvalue = 0.0
    variable = e
    invalue = 1.0
    type = SmoothCircleIC
  [../]
  [./PolycrystalICs]
    [./BicrystalBoundingBoxIC]
      var_name_base = eta
      y2 = 20
      op_num = 2
      y1 = 0
      x2 = 25
      x1 = 0
    [../]
  [../]
[]

