within BusinessSimulation.MoleculesOfStructure.Transceivers;

model SplitFlow "Splitting an arbitrary flow into n subflows"
  extends Interfaces.Basics.OutputTypeChoice(redeclare replaceable type OutputType = Units.Rate);
  extends Icons.SubsystemTransceiver;
  RealMultiOutput[nout] y "Rates of the split flows" annotation(Placement(visible = true, transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 104}, extent = {{-10, -10}, {10, 10}}, rotation = -270)));
  Interfaces.Connectors.StockPort stockPort "Connected to incoming flow to be split or broken up" annotation(Placement(visible = true, transformation(origin = {-148.287, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Connectors.FlowMultiPort flowPort[nout] "n-dimensional array of outgoing flows" annotation(Placement(visible = true, transformation(origin = {147.761, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Connectors.RealMultiInput u[nout] if not hasConstantWeights "Vector of weights for the splits or breaks" annotation(Placement(visible = true, transformation(origin = {-145, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  parameter Real[nout] weights = ones(nout) "Constant weights for splitting (optional)" annotation(Dialog(enable = hasConstantWeights));
  parameter Integer nout(min = 1) = 2 "Number of flows to split into" annotation(Dialog(group = "Structural Parameters"));
  parameter Boolean hasConstantWeights = false "= true, if the weights are constant parameters" annotation(Evaluate = true, Dialog(group = "Structural Parameters"));
  parameter Boolean isSplit = true "= true, if the input given is assumed to be weights (adding up to one) splitting the flow" annotation(Evaluate = true, Dialog(group = "Structural Parameters"));
  parameter Boolean shiftInputs = false "= true, if all values are to be shifted to prevent negative inputs, otherwise negative inputs are simply set to zero (proportionalSplitFactors.shiftInputs)" annotation(Dialog(enable = isSplit, group = "Structural Parameters"));
protected
  Converters.Vector.ProportionalSplitFactors proportionalSplitFactors(nin = nout, shiftInputs = shiftInputs) if isSplit "Split factors adding up to one" annotation(Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Converters.PassThrough unchangedInput[nout] if not isSplit annotation(Placement(visible = true, transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sensors.StockPortSensor_Control sensor_A "Measuring the flow and seting the flags" annotation(Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sensors.FlowPortSensor_Control sensor_B[nout] "Measuring stock level and Boolean flags" annotation(Placement(visible = true, transformation(origin = {110, 11.975}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Converters.Logical.AnyTrue stopInflow(nin = nout) annotation(Placement(visible = true, transformation(origin = {20, 25}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Converters.Logical.AnyTrue stopOutflow(nin = nout) annotation(Placement(visible = true, transformation(origin = {50, 15}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Converters.Vector.ConstantConverter parWeights(value = weights, redeclare replaceable type OutputType = Units.Dimensionless) if hasConstantWeights "Constant weights for splitting (optional)" annotation(Placement(visible = true, transformation(origin = {-135, 95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Flows.Bidirectional.Switching splitFlows[nout] "The splitted outflow" annotation(Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SourcesOrSinks.Cloud cloudOutflow "Cloud connected to the aggregate outflow" annotation(Placement(visible = true, transformation(origin = {-90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  SourcesOrSinks.Cloud[nout] cloudBrokenFlow "Clouds connected to the broken flows" annotation(Placement(visible = true, transformation(origin = {-70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Converters.Vector.ScalarMultiplication splitRates(nin = nout) "The rates for the split flows" annotation(Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(cloudBrokenFlow.massPort, splitFlows.portA) annotation(Line(visible = true, origin = {-50, 0}, points = {{-10, 0}, {10, 0}}, color = {128, 0, 128}));
  connect(splitFlows.portB, flowPort) annotation(Line(visible = true, origin = {63.88, 0}, points = {{-83.88, 0}, {83.88, 0}}, color = {128, 0, 128}));
  connect(proportionalSplitFactors.y, splitRates.u1) annotation(Line(visible = true, origin = {-81.782, 52.519}, points = {{-0.218, 7.481}, {16.782, 7.481}, {16.782, -7.557}, {23.744, -7.557}}, color = {1, 37, 163}));
  connect(u, proportionalSplitFactors.u) annotation(Line(visible = true, origin = {-121.5, 60}, points = {{-23.5, 0}, {23.5, 0}}, color = {1, 37, 163}));
  connect(splitRates.y, splitFlows.u) annotation(Line(visible = true, origin = {-37.5, 30}, points = {{-5, 10}, {2.5, 10}, {2.5, -20}}, color = {1, 37, 163}));
  connect(u, unchangedInput.u) annotation(Line(visible = true, origin = {-136.568, 70}, points = {{-8.432, -10}, {1.568, -10}, {1.568, 10}, {38.568, 10}}, color = {1, 37, 163}));
  connect(unchangedInput.y, splitRates.u1) annotation(Line(visible = true, origin = {-82.908, 62.481}, points = {{0.908, 17.519}, {17.908, 17.519}, {17.908, -17.519}, {24.87, -17.519}}, color = {1, 37, 163}));
  connect(stockPort, sensor_A.stockPort) annotation(Line(visible = true, origin = {-139.144, 0}, points = {{-9.143, 0}, {9.144, 0}}, color = {128, 0, 128}));
  connect(sensor_A.flowPort, cloudOutflow.massPort) annotation(Line(visible = true, origin = {-105.118, 0}, points = {{-5.118, 0}, {5.118, -0}}, color = {128, 0, 128}));
  connect(sensor_A.netFlow, splitRates.u2) annotation(Line(visible = true, origin = {-94.804, 29.009}, points = {{-25.172, -18.009}, {-25.172, 5.991}, {36.766, 5.991}, {36.766, 6.029}}, color = {1, 37, 163}));
  connect(sensor_B.flowPort, flowPort) annotation(Line(visible = true, origin = {135.174, 7.983}, points = {{-25.174, 3.992}, {12.587, 3.992}, {12.587, -7.983}}, color = {128, 0, 128}));
  connect(sensor_B.stopInflow, stopInflow.u) annotation(Line(visible = true, origin = {97.5, 19.987}, points = {{14.5, -5.013}, {27.5, -5.013}, {27.5, 5.013}, {-69.5, 5.013}}, color = {255, 0, 255}));
  connect(sensor_B.stopOutflow, stopOutflow.u) annotation(Line(visible = true, origin = {89, 14.987}, points = {{19, -0.013}, {6, -0.013}, {6, 0.013}, {-31, 0.013}}, color = {255, 0, 255}));
  connect(stopInflow.y, sensor_A.u_stopInflow) annotation(Line(visible = true, origin = {-79.333, 20}, points = {{91.333, 5}, {-45.667, 5}, {-45.667, -10}}, color = {255, 0, 255}));
  connect(stopOutflow.y, sensor_A.u_stopOutflow) annotation(Line(visible = true, origin = {-62.667, 13.333}, points = {{104.667, 1.667}, {-52.334, 1.667}, {-52.334, -3.334}}, color = {255, 0, 255}));
  connect(splitFlows.y, y) annotation(Line(visible = true, origin = {33.333, 30.133}, points = {{-58.333, -19.733}, {-58.333, 9.867}, {116.667, 9.867}}, color = {1, 37, 163}));
  connect(parWeights.y, unchangedInput.u) annotation(Line(visible = true, origin = {-116.75, 87.5}, points = {{-12.25, 7.5}, {-3.25, 7.5}, {-3.25, -7.5}, {18.75, -7.5}}, color = {1, 37, 163}));
  connect(parWeights.y, proportionalSplitFactors.u) annotation(Line(visible = true, origin = {-116.75, 77.5}, points = {{-12.25, 17.5}, {-3.25, 17.5}, {-3.25, -17.5}, {18.75, -17.5}}, color = {1, 37, 163}));
  annotation(Documentation(info = "<html>
<p class=\"aside\">This information is part of the Business Simulation&nbsp;Library (BSL).</p>
<p>The flow connected to the stock port (<code>stockPort</code>) will be split or broken into <em>n</em> = <code>nout</code> flows. This is a rather generic component, so that the input vector <strong>u</strong>&nbsp;of weights or factors may add up to 1 (the flow is split into <em>n</em> components that in sum will match the aggregate flow) or not.</p>
<p>When the factors do not add up to 1, the structure can be used to describe some kind of multiple-production from one main effort, e.g. the flow of work hours per period may be used to produce n products according to a productivity ratio ( products per work hour ).</p>
<h4>Notes</h4>
<ul>
<li>Unlike the model published by Jim Hines [<a href=\"modelica://BusinessSimulation.UsersGuide.References\">6</a>, p. 17] the <em>SplitFlow</em> component is more general and also allows a bidirectional flow being connected to <code>stockPort</code>. If a negative rate at <code>stockPort</code> splits an inflow to a stock, then several stocks connected to <code>flowPort</code> will be drained.</li><br>
<li>The component will observe the <code>stopInflow</code> and <code>stopOutflow</code> signals at its <code>flowPort</code>, so that if <em>any</em> of these are <code>true</code>, the corresponding signal will be set to <code>true</code> at the stockPort side.</li>
</ul>
<h4>See also</h4>
<a href=\"modelica://BusinessSimulation.Converters.Vector.ProportionalSplitFactors\">ProportionalSplitFactors</a>,
<a href=\"modelica://BusinessSimulation.Flows.Interaction.BrokenTransition\">BrokenTransition</a>,
<a href=\"modelica://BusinessSimulation.Flows.Interaction.BrokenTransitionPull\">BrokenTransitionPull</a>
</html>"), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {10, 10}), graphics = {Line(visible = true, origin = {21.891, 0}, points = {{0, 0}, {18.109, 0}}, color = {0, 128, 0}, thickness = 5), Ellipse(visible = true, origin = {32.283, 0}, lineColor = {0, 128, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-4.138, -4.138}, {4.138, 4.138}}), Text(visible = true, origin = {0, 75}, textColor = {76, 112, 136}, extent = {{-100, -12}, {100, 12}}, textString = "Split Flow", fontName = "Lato Black", textStyle = {TextStyle.Bold}), Rectangle(visible = true, origin = {4, 32.089}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-10, -10}, {10, 10}}), Line(visible = true, origin = {7.759, 28.479}, points = {{-10.617, 2.61}, {-8.681, 8.473}, {-0.406, -1.527}, {2.998, 2.61}, {-0.784, 8.473}, {-7.213, -1.172}, {-10.617, 2.61}}, color = {255, 0, 0}, thickness = 1.5, smooth = Smooth.Bezier), Polygon(visible = true, origin = {42.453, 31.814}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{-2.773, 3.823}, {-2.773, -3.863}, {5.547, 0.041}}), Rectangle(visible = true, origin = {4, 0}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-10, -10}, {10, 10}}), Line(visible = true, origin = {7.759, -3.61}, points = {{-10.617, 2.61}, {-8.681, 8.473}, {-0.406, -1.527}, {2.998, 2.61}, {-0.784, 8.473}, {-7.213, -1.172}, {-10.617, 2.61}}, color = {255, 0, 0}, thickness = 1.5, smooth = Smooth.Bezier), Polygon(visible = true, origin = {42.453, -0.275}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{-2.773, 3.823}, {-2.773, -3.863}, {5.547, 0.041}}), Line(visible = true, origin = {21.891, -32.153}, points = {{0, 0}, {18.109, 0}}, color = {0, 128, 0}, thickness = 5), Ellipse(visible = true, origin = {31.978, -31.884}, lineColor = {0, 128, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-4.138, -4.138}, {4.138, 4.138}}), Rectangle(visible = true, origin = {4, -31.884}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-10, -10}, {10, 10}}), Line(visible = true, origin = {7.759, -35.495}, points = {{-10.617, 2.61}, {-8.681, 8.473}, {-0.406, -1.527}, {2.998, 2.61}, {-0.784, 8.473}, {-7.213, -1.172}, {-10.617, 2.61}}, color = {255, 0, 0}, thickness = 1.5, smooth = Smooth.Bezier), Polygon(visible = true, origin = {42.453, -32.159}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{-2.773, 3.823}, {-2.773, -3.863}, {5.547, 0.041}}), Rectangle(visible = true, origin = {-49, 0}, lineColor = {255, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 3, extent = {{-10, -10}, {10, 10}}), Line(visible = true, origin = {-44.998, -3.473}, points = {{-10.617, 2.61}, {-8.681, 8.473}, {-0.406, -1.527}, {2.998, 2.61}, {-0.784, 8.473}, {-7.213, -1.172}, {-10.617, 2.61}}, color = {255, 0, 0}, thickness = 1.5, smooth = Smooth.Bezier), Line(visible = true, origin = {-39.586, -75.667}, points = {{9.586, 100.926}, {9.586, 93.462}, {71.923, 93.462}, {71.923, 87.412}}, color = {0, 0, 128}, thickness = 2), Line(visible = true, origin = {-39.586, -106.737}, points = {{9.586, 126.737}, {9.586, 90.254}, {71.771, 90.254}, {71.771, 86.737}}, color = {0, 0, 128}, thickness = 2), Polygon(visible = true, origin = {31.328, 40.586}, rotation = -90, lineColor = {0, 0, 128}, fillColor = {0, 0, 128}, fillPattern = FillPattern.Solid, points = {{-2.773, 2.672}, {-2.773, -2.623}, {3.945, -0.02}}), Polygon(visible = true, origin = {32.328, 8.227}, rotation = -90, lineColor = {0, 0, 128}, fillColor = {0, 0, 128}, fillPattern = FillPattern.Solid, points = {{-2.773, 2.672}, {-2.773, -2.623}, {3.945, -0.02}}), Polygon(visible = true, origin = {31.975, -23.773}, rotation = -90, lineColor = {0, 0, 128}, fillColor = {0, 0, 128}, fillPattern = FillPattern.Solid, points = {{-2.773, 2.672}, {-2.773, -2.623}, {3.945, -0.02}}), Line(visible = true, origin = {-38.586, -43.462}, points = {{-36.613, 48.343}, {-36.613, 68}, {8.586, 68}, {8.586, 93.462}, {70.313, 93.462}, {70.313, 88.612}}, color = {0, 0, 128}, thickness = 2), Line(visible = true, origin = {-82.434, 0}, points = {{0, 0}, {15.777, 0}}, color = {0, 128, 0}, thickness = 5), Ellipse(visible = true, origin = {-75.022, 0.089}, lineColor = {0, 128, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-4.138, -4.138}, {4.138, 4.138}}), Polygon(visible = true, origin = {-65.547, -0.186}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{-2.773, 3.823}, {-2.773, -3.863}, {5.547, 0.041}}), Text(visible = true, origin = {0, -70}, extent = {{-97.365, -6}, {97.365, 6}}, textString = "n = %nout", fontName = "Lato", textStyle = {TextStyle.Bold}), Polygon(visible = true, origin = {-84.453, 0.02}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{2.773, 3.823}, {2.773, -3.863}, {-5.547, 0.041}}), Polygon(visible = true, origin = {21.644, -31.928}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{2.773, 3.823}, {2.773, -3.863}, {-5.547, 0.041}}), Polygon(visible = true, origin = {21.644, 0.072}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{2.773, 3.823}, {2.773, -3.863}, {-5.547, 0.041}}), Polygon(visible = true, origin = {21.644, 32.072}, lineColor = {0, 128, 0}, fillColor = {0, 128, 0}, fillPattern = FillPattern.Solid, points = {{2.773, 3.823}, {2.773, -3.863}, {-5.547, 0.041}}), Line(visible = true, origin = {22.891, 32}, points = {{0, 0}, {18.109, 0}}, color = {0, 128, 0}, thickness = 5), Ellipse(visible = true, origin = {31.978, 32.089}, lineColor = {0, 128, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-4.138, -4.138}, {4.138, 4.138}})}), Diagram(coordinateSystem(extent = {{-148.5, -105}, {148.5, 105}}, preserveAspectRatio = true, initialScale = 0.1, grid = {5, 5})));
end SplitFlow;