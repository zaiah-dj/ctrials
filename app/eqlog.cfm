<cfscript>
//Pull the site GUID (should be in session variable, so this probably won't be here in the future...
siteGUID = ezdb.exec( 
	bindArgs = { siteId = '999' }
 ,string = "select siteGUID from #data.data.participants# where siteID = :siteId"
).results.siteGUID;


//Pull a list of all machines relevant to the current site and exercise type.
eqlog = ezdb.exec(
	bindArgs = { 
		site_guid = siteGUID 
	 ,exercise_guid = '268AA2A1-24B9-439D-A249-8BB77C14A203'
	}
 ,string = "
	select
	*
	from
		/* This just joins all the equipment data perhaps for use with my app*/
		( select * from
			(select * from
				( select 
						siteGUID
					 ,equipmentGUID
					 ,settingGUID	
					from equipmentTracking ) as et1

				inner join

				( select 
						settingGUID as msetting_guid
					 ,settingDescription
					from 
						equipmentTrackingSettings ) as md_2

				on md_2.msetting_guid = et1.settingGUID
				) as et

		inner join
			( select 
					siteGUID as eq_siteguid
				 ,machineGUID
				 ,equipmentGUID as eq_equipmentguid
				 ,exerciseGUID
				 ,interventionGUID
				 ,active
				from equipmentTrackingEquipment ) as eq
		on eq.eq_siteguid = et.siteGUID
		) as SiteData 

	inner join

		/* This should get the machine names and settings... */
			( select * from
				( 
					select * from
					( select
							machineGUID
						 ,manufacturerGUID as mmfg_guid
						 ,modelGUID as mmodel_guid
						from equipmentTrackingMachines ) as machines
					inner join
					( select
							modelDescription 
						 ,modelGUID as model_guid
						from equipmentTrackingModels ) as models
					on machines.mmodel_guid = models.model_guid 
				) as machineAndModel

				inner join

				(
					select 
						manufacturerGUID as mfg_guid
					 ,manufacturerDescription
					from equipmentTrackingManufacturers 
				) as mfg

				on machineAndModel.mmfg_guid = mfg.mfg_guid
			
			) as MachineData
	ON 	
		SiteData.machineGUID = MachineData.machineGUID
	WHERE 
		SiteData.siteGUID = :site_guid
	AND 
		SiteData.exerciseGUID = :exercise_guid
	"
);
</cfscript>
