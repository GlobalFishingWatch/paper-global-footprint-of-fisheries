# Updated Algorithm for Squid Jiggers

Between paper acceptance and publication of our paper, we changed how our dataset calculates fishing activity for squid jiggers, and this change is reflected in the dataset we have released. 

These vessels make up a small fraction of the vessels in our database; about 600 out of 70,000 mmsi are likely squid jiggers. Our fishing effort training data included all our other major geartypes, but did not include this gear type. As a result, the neural net model did a poor job at identifying when these vessles were fishing, and falsely labeled many of the transits of these vessels as fishing activty.

Based on conversations with experts and a review of the activity of the squid fleet operating outside the Peruvian exclusive economic zone, we developed a heuristic to account for squid fishing activity. These vessels fish only at night and only while relatively stationary. Rather than retrain the neural net model, we applied this hueristic to all squid vessels. The heuristic labels positions as fishing if the vessel is > 10 nautical miles from shore and moving slower than 1.5 knots at night for more than four hours. We eventually plan to eventually provide training data for our model to better identify likely fishing activity by Squid Jiggers.			

![squid fishing](../images/global_plot_squid.jpg)
