# This simulation predicts GB migration of a 2D UO2 polycrystal with 100 grains represented with 15 order parameters
# Mesh adaptivity and time step adaptivity are used
# An AuxVariable is used to visualize the grain boundary locations
# Postprocessors are used to record time step and the number of grains

[Mesh]
  # Mesh block.  Meshes can be read in or automatically generated
  type = GeneratedMesh
  dim = 2 # Problem dimension
  nx = 12 # Number of elements in the x-direction
  ny = 12 # Number of elements in the y-direction
  xmin = 0 # minimum x-coordinate of the mesh
  xmax = 1000 # maximum x-coordinate of the mesh
  ymax = 1000 # maximum y-coordinate of the mesh
  elem_type = QUAD4 # Type of elements used in the mesh
  uniform_refine = 3 # Initial uniform refinement of the mesh
[]

[GlobalParams]
  # Parameters used by several kernels that are defined globally to simplify input file
  op_num = 17 # Number of order parameters used
  var_name_base = gr # Base name of grains
  time_scale = 1.0 # Time scale in seconds
[]

[Variables]
  # Variable block, where all variables in the simulation are declared
  [./PolycrystalVariables]
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiIC]
      grain_num = 100 #Number of grains
    [../]
  [../]
[]

[AuxVariables]
  # Dependent variables
  [./bnds]
    # Variable used to visualize the grain boundaries in the simulation
    order = FIRST
    family = LAGRANGE
  [../]
  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  # Kernel block, where the kernels defining the residual equations are set up.
  [./PolycrystalKernel]
    # Custom action creating all necessary kernels for grain growth.  All input parameters are up in GlobalParams
  [../]
[]

[AuxKernels]
  # AuxKernel block, defining the equations used to calculate the auxvars
  [./bnds_aux]
    # AuxKernel that calculates the GB term
    type = BndsCalcAux
    variable = bnds
    execute_on = timestep_end
  [../]
  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    execute_on = timestep_end
    bubble_object = grain_tracker
    field_display = UNIQUE_REGION
  [../]
  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    execute_on = timestep_end
    bubble_object = grain_tracker
    field_display = VARIABLE_COLORING
  [../]
[]

[BCs]
  # Boundary Condition block
  [./Periodic]
    [./top_bottom]
      auto_direction = 'x y' # Makes problem periodic in the x and y directions
    [../]
  [../]
[]

[Materials]
  [./UO2GrGr]
    # Material properties
    type = UO2GrGr # Quantitative material properties for copper grain growth.  Dimensions are nm and ns
    block = 0 # Block ID (only one block in this problem)
    T = 1300 # Constant temperature of the simulation (for mobility calculation)
    wGB = 14 # Width of the diffuse GB
  [../]
[]

[Postprocessors]
  # Scalar postprocessors
  [./grain_tracker]
    type = GrainTracker
    threshold = 0.2
    convex_hull_buffer = 5.0
    use_single_map = false
    enable_var_coloring = true
    condense_map_info = true
    connecting_threshold = 0.08
    flood_entity_type = elemental
    execute_on = 'initial timestep_end'
  [../]
  [./dt]
    # Outputs the current time step
    type = TimestepSize
  [../]
[]

[Executioner]
  type = Transient # Type of executioner, here it is transient with an adaptive time step
  scheme = bdf2 # Type of time integration (2nd order backward euler), defaults to 1st order backward euler

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -mat_mffd_type'
  petsc_options_value = 'hypre boomeramg 31 ds'
  l_max_its = 15 # Max number of linear iterations
  l_tol = 1e-4 # Relative tolerance for linear solves
  nl_max_its = 15 # Max number of nonlinear iterations
  nl_rel_tol = 1e-9 # Relative tolerance for nonlienar solves
  start_time = 0.0
  num_steps = 50
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 100 # Initial time step.  In this simulation it changes.
    optimal_iterations = 8 # Time step will adapt to maintain this number of nonlinear iterations
    growth_factor = 1.2
    cutback_factor = 0.75
  [../]
  [./Adaptivity]
    # Block that turns on mesh adaptivity. Note that mesh will never coarsen beyond initial mesh (before uniform refinement)
    initial_adaptivity = 2 # Number of times mesh is adapted to initial condition
    refine_fraction = 0.7 # Fraction of high error that will be refined
    coarsen_fraction = 0.1 # Fraction of low error that will coarsened
    max_h_level = 4 # Max number of refinements used, starting from initial mesh (before uniform refinement)
  [../]
[]

[Outputs]
  file_base = tracker_UO2_2D # Output base file name.  Note the output will be saved in the "output" directory, that MUST be created before you run the simulation
  output_initial = true # Output initial condition
  exodus = true # Exodus file will be outputted
  csv = true
  print_perf_log = true
[]
