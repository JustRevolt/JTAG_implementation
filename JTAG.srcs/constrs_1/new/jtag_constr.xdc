#set_property IOSTANDARD LVCMOS33 [get_ports {anlz_dec_data_o[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {anlz_dec_data_o[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {anlz_dec_data_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_pass_i[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_pass_i[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_pass_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dec_data_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dec_data_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dec_data_o[0]}]
#set_property PACKAGE_PIN E16 [get_ports {anlz_dec_data_o[0]}]
#set_property PACKAGE_PIN F13 [get_ports {anlz_dec_data_o[1]}]
#set_property PACKAGE_PIN G13 [get_ports {anlz_dec_data_o[2]}]
set_property PACKAGE_PIN J15 [get_ports {data_pass_i[0]}]
set_property PACKAGE_PIN L16 [get_ports {data_pass_i[1]}]
set_property PACKAGE_PIN M13 [get_ports {data_pass_i[2]}]
set_property PACKAGE_PIN H17 [get_ports {dec_data_o[0]}]
set_property PACKAGE_PIN K15 [get_ports {dec_data_o[1]}]
set_property PACKAGE_PIN J13 [get_ports {dec_data_o[2]}]
#set_property PACKAGE_PIN K1 [get_ports anlz_dec_clk_o]
#set_property PACKAGE_PIN F6 [get_ports anlz_dec_rst_o]
#set_property PACKAGE_PIN H4 [get_ports anlz_tap_tck_o]
#set_property PACKAGE_PIN G1 [get_ports anlz_tap_tdi_o]
#set_property PACKAGE_PIN G3 [get_ports anlz_tap_tdo_o]
#set_property PACKAGE_PIN H1 [get_ports anlz_tap_tms_o]
set_property PACKAGE_PIN N17 [get_ports dec_clk_i]
set_property PACKAGE_PIN C12 [get_ports dec_rst_i]
set_property PACKAGE_PIN G17 [get_ports tap_tck_i]
set_property PACKAGE_PIN D18 [get_ports tap_tdi_i]
set_property PACKAGE_PIN C17 [get_ports tap_tdo_o]
set_property PACKAGE_PIN E18 [get_ports tap_tms_i]
set_property PACKAGE_PIN P17 [get_ports test_reg_i]
#set_property IOSTANDARD LVCMOS33 [get_ports anlz_dec_clk_o]
#set_property IOSTANDARD LVCMOS33 [get_ports anlz_dec_rst_o]
#set_property IOSTANDARD LVCMOS33 [get_ports anlz_tap_tck_o]
#set_property IOSTANDARD LVCMOS33 [get_ports anlz_tap_tdi_o]
#set_property IOSTANDARD LVCMOS33 [get_ports anlz_tap_tdo_o]
#set_property IOSTANDARD LVCMOS33 [get_ports anlz_tap_tms_o]
set_property IOSTANDARD LVCMOS33 [get_ports dec_clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports dec_rst_i]
set_property IOSTANDARD LVCMOS33 [get_ports tap_tck_i]
set_property IOSTANDARD LVCMOS33 [get_ports tap_tdi_i]
set_property IOSTANDARD LVCMOS33 [get_ports tap_tdo_o]
set_property IOSTANDARD LVCMOS33 [get_ports tap_tms_i]
set_property IOSTANDARD LVCMOS33 [get_ports test_reg_i]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets anlz_tap_tck_o_OBUF]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tap_tck_i_IBUF]

