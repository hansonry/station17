
local function make_table_using_key(array, keyName)
   local t={}
   local function toKeyText(text)
      return string.gsub(text, " ", "_"):lower()
   end
   for i,v in ipairs(array) do
      local key = toKeyText(v[keyName])
      t[key] = v
   end
   return t
end

local access_ordered = {
   { name = "Command" },
   { name = "Captain Office" },
   { name = "Head Of Personnel Office" },
   { name = "Security" },
   { name = "Head Of Security Office" },
   { name = "Cargo" },
   { name = "Mining" },
   { name = "Quarter Master Office" },
   { name = "Engineering" },
   { name = "Chief Engineer Office" },
   { name = "Kitchen" },
   { name = "Botany" },
   { name = "Science" },
   { name = "Research Director Office" },
   { name = "Medical" },
   { name = "Chief Medical Officer Office" },
   { name = "Clown Office" },
   { name = "Maintenance" },
   { name = "Crew" },
}

local access = make_table_using_key(access_ordered, "name")



local jobs_ordered = {
   { 
      name = "Captain",
      permissions = { 
         access.command, 
         access.captain_office,
         access.head_of_personnel_office,
         access.security,
         access.head_of_security_office,
         access.cargo,
         access.mining,
         access.quarter_master_office,
         access.engineering,
         access.chief_engineer_office,
         access.kitchen,
         access.botany,
         access.science,
         access.research_director_office,
         access.medical,
         access.chief_medical_officer_office,
         access.clown_office,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Head Of Personnel",
      permissions = { 
         access.command, 
         access.head_of_personnel_office,
         access.security,
         access.kitchen,
         access.botany,
         access.cargo,
         access.mining,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Botanist",
      permissions = { 
         access.botany,
         access.crew
      } 
   },   
   { 
      name = "Chef", 
      permissions = { 
         access.kitchen,
         access.crew
      } 
   },
   { 
      name = "Bartender",
      permissions = {
         access.crew
      } 
   },
   { 
      name = "Janitor",
      permissions = {
         access.crew
      } 
   },
   { 
      name = "Quarter Master",
      permissions = {
         access.cargo,
         access.mining,
         access.quarter_master_office,
         access.crew
      }
   },
   { 
      name = "Miner",
      permissions = {
         access.cargo,
         access.mining,
         access.crew
      }
   },
   { 
      name = "Cargo Technician",
      permissions = {
         access.cargo,
         access.crew
      }
   },
   { 
      name = "Head Of Security",
      permissions = { 
         access.command, 
         access.security,
         access.head_of_security_office,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Security Officer",
      permissions = { 
         access.security,
         access.maintenance,
         access.crew
      }       
   },
   { 
      name = "Chief Medical Officer",
      permissions = { 
         access.command, 
         access.medical,
         access.chief_medical_officer_office,
         access.crew
      }
   },
   { 
      name = "Doctor",
      permissions = { 
         access.command, 
         access.medical,
         access.crew
      }
   },
   { 
      name = "Chief Engineer",
      permissions = { 
         access.command, 
         access.engineering,
         access.chief_engineer_office,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Engineer",
      permissions = { 
         access.engineering,
         access.maintenance,
         access.crew
      } 
   },
   { 
      name = "Research Director",
      permissions = { 
         access.command, 
         access.science,
         access.research_director_office,
         access.crew
      } 
   },
   { 
      name = "Scientist",
      permissions = { 
         access.science,
         access.research_director_office,
         access.crew
      }       
   },
   {
      name = "Clown",
      permissions = { 
         --access.command, 
         --access.captain_office, -- :D
         access.clown_office,
         access.crew
      }
   },
   {
      name = "Assistant",
      permissions = { 
         access.crew
      }
   }
}
local jobs = make_table_using_key(jobs_ordered, "name")

spacestation.jobs_ordered   = jobs_ordered
spacestation.jobs           = jobs
spacestation.access_ordered = access_ordered
spacestation.access         = access





