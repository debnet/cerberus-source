/*
 * Cerberus  Copyright (C) 2013  vertigo17
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This file is part of Cerberus.
 *
 * Cerberus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Cerberus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Cerberus.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.cerberus.servlet.campaign;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Level;
import org.cerberus.entity.Campaign;
import org.cerberus.entity.CampaignContent;
import org.cerberus.entity.CampaignParameter;
import org.cerberus.exception.CerberusException;
import org.cerberus.log.MyLogger;
import org.cerberus.service.ICampaignService;
import org.cerberus.servlet.invariant.GetInvariantList;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 *
 * @author memiks
 */
@WebServlet(name = "GetCampaign", urlPatterns = {"/GetCampaign"})
public class GetCampaign extends HttpServlet {

    private ICampaignService campaignService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ApplicationContext appContext = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
        campaignService = appContext.getBean(ICampaignService.class);
        PolicyFactory policy = Sanitizers.FORMATTING.and(Sanitizers.LINKS);

        String action = policy.sanitize(request.getParameter("action"));
        String campaign = policy.sanitize(request.getParameter("campaign"));
        String testBattery = policy.sanitize(request.getParameter("TestBattery"));

        try {
            JSONObject jsonResponse = new JSONObject();
            try {
                if (action != null && "findAllCampaign".equals(action.trim())) {
                    jsonResponse.put("Campaigns", findAllCampaignToJSON());
                } else if (action != null && "findAllCampaignContent".equals(action.trim())) {
                    jsonResponse.put("CampaignContents", findAllCampaignContentToJSON(campaignService.findCampaignByKey(Integer.parseInt(campaign)).getCampaign()));

                } else if (action != null && "findAllCampaignParameter".equals(action.trim())) {
                    jsonResponse.put("CampaignParameters", findAllCampaignParameterToJSON(campaignService.findCampaignByKey(Integer.parseInt(campaign)).getCampaign()));

                } else if (action != null && "findCampaignFromTestBattery".equals(action.trim())) {
                    jsonResponse.put("Campaigns", findCampaignFromTestBatteryToJSON(testBattery));

                }
            } catch (CerberusException ex) {
                response.setContentType("text/html");
                response.getWriter().print(ex.getMessageError().getDescription());

            }
            response.setContentType("application/json");
            response.getWriter().print(jsonResponse.toString());
        } catch (JSONException e) {
            MyLogger.log(GetInvariantList.class.getName(), Level.FATAL, "" + e);
            response.setContentType("text/html");
            response.getWriter().print(e.getMessage());
        }
    }

    private JSONArray findAllCampaignToJSON() throws JSONException, CerberusException {
        JSONArray jsonResponse = new JSONArray();
        for (Campaign campaign : campaignService.findAll()) {
            jsonResponse.put(convertCampaignToJSONObject(campaign, true));
        }

        return jsonResponse;
    }

    private JSONArray findAllCampaignContentToJSON(String campaign) throws JSONException, CerberusException {
        JSONArray jsonResponse = new JSONArray();
        for (CampaignContent campaignContent : campaignService.findCampaignContentsByCampaignName(campaign)) {
            jsonResponse.put(convertCampaignContentToJSONObject(campaignContent));
        }

        return jsonResponse;
    }

    private JSONArray findAllCampaignParameterToJSON(String campaign) throws JSONException, CerberusException {
        JSONArray jsonResponse = new JSONArray();
        for (CampaignParameter campaignParameter : campaignService.findCampaignParametersByCampaignName(campaign)) {
            jsonResponse.put(convertCampaignParameterToJSONObject(campaignParameter));
        }

        return jsonResponse;
    }

    private JSONArray findCampaignFromTestBatteryToJSON(String testBattery) throws JSONException, CerberusException {
        JSONArray jsonResponse = new JSONArray();
        for (CampaignContent campaignContent : campaignService.findCampaignContentByCriteria(null, null, testBattery)) {
            jsonResponse.put(convertCampaignToJSONObject(campaignService.findCampaignByCampaignName(campaignContent.getCampaign()), false));
        }

        return jsonResponse;
    }

    private JSONArray convertCampaignToJSONObject(Campaign campaign, boolean withLink) throws JSONException {
        JSONArray result = new JSONArray();
        result.put(campaign.getCampaignID());
        if (withLink) {
            result.put(campaign.getCampaign() + "<a onclick='viewListOfTests(" + campaign.getCampaignID() + ");' title='View list of tests'><img src='images/details_open.png'/></a>");
        } else {
            result.put(campaign.getCampaign());
        }
        result.put(campaign.getDescription());
        return result;
    }

    private JSONArray convertCampaignContentToJSONObject(CampaignContent campaignContent) throws JSONException {
        JSONArray result = new JSONArray();
        result.put(campaignContent.getCampaigncontentID());
        result.put(campaignContent.getCampaign());
        result.put(campaignContent.getTestbattery());
        return result;
    }

    private JSONArray convertCampaignParameterToJSONObject(CampaignParameter campaignParameter) throws JSONException {
        JSONArray result = new JSONArray();
        result.put(campaignParameter.getCampaignparameterID());
        result.put(campaignParameter.getCampaign());
        result.put(campaignParameter.getParameter());
        result.put(campaignParameter.getValue());
        return result;
    }
}
