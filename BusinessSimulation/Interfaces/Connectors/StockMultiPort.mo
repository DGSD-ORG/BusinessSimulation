within BusinessSimulation.Interfaces.Connectors;

connector StockMultiPort "Used to represent multiple stock connectors"
  extends StockPort;
  annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {10, 10}), graphics = {Rectangle(visible = true, origin = {-5, 5}, lineColor = {128, 0, 128}, fillColor = {128, 0, 128}, fillPattern = FillPattern.Solid, lineThickness = 5, extent = {{-55, -55}, {55, 55}})}), Documentation(info = "<html>
<p class=\"aside\">This information is part of the Business Simulation&nbsp;Library (BSL). Please support this work and <a href=\"https://www.paypal.com/donate/?hosted_button_id=GXVZT8LD7CFXN\" style=\"font-weight:bold; color:orange; text-decoration:none;\">&#9658;&nbsp;donate</a>.</p>
<p>The <em>StockPort</em><em>&nbsp;</em>is a <em>composite</em> connector and&nbsp;consists of an <em>acausal connector</em> with the <strong>Real potential</strong> variable <code>stock</code> indicating the stored amount in a reservoir and the <strong>Real flow</strong> variable <code>rate</code> indicating the rate of flow <em>into</em> (<code>rate &gt; 0</code>) or <em>out of</em> (<code>rate &lt; 0</code>) the reservoir.</p>
<p>There are also two <strong>Boolean output variables</strong>, which indicate whether draining the reservoir (<code>stopOutflow</code>) or filling it (<code>stopInflow</code>) is prohibited. Since a generic reservoir will have two ports it is possible to allow inflows and outflows on both ports (standard) or give the stock a clear direction of flow with one port serving as <code>inflow</code> and the other as <code>outflow</code> connector.</p>

</html>"), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {10, 10}), graphics = {Ellipse(visible = true, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-24.747, -24.747}, {24.747, 24.747}})}));
end StockMultiPort;
